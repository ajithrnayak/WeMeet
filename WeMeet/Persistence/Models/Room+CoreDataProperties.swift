//
//  Room+CoreDataProperties.swift
//  WeMeet
//
//  Created by Ajith Renjala on 03/08/23.
//
//

import Foundation
import CoreData


extension Room {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room")
    }

    @NSManaged public var name: String
    @NSManaged public var spots: Int16
    @NSManaged public var thumbnail: String
    @NSManaged public var id: UUID

}

extension Room : Identifiable {

}
