//
//  Room+CoreDataClass.swift
//  WeMeet
//
//  Created by Ajith Renjala on 03/08/23.
//
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

public class Room: NSManagedObject, Decodable {

    public var thumbnailURL: URL {
        URL(string: thumbnail)!
    }

    public var hasRemainingSpots: Bool {
        spots > 0
    }

    public var remainingSpotsLabel: String {
        hasRemainingSpots ? "\(spots) spots remaining" : "No available spots"
    }

    // MARK: - Codable

    enum CodingKeys: CodingKey {
        case id, name, spots, thumbnail
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.spots = try container.decode(Int16.self, forKey: .spots)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
    }
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

public extension Room {
    static var example: Room {
        Room()
    }

    static func roomsFetchRequest() -> NSFetchRequest<Room> {
        let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
        fetchRequest.includesPendingChanges = true
        fetchRequest.fetchBatchSize = PersistenceStore.defaultBatchSize
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Room.name, ascending: false)]
        return fetchRequest
    }
}

