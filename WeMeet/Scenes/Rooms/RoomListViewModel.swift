//
//  RoomListViewModel.swift
//  WeMeet
//
//  Created by Ajith Renjala on 01/08/23.
//

import Foundation

struct RoomsResponse: Decodable {
    let rooms: [Room]
}

struct Room: Codable, Identifiable {
    var id: String { name }
    let name: String
    let spots: Int
    let thumbnail: String

    var thumbnailURL: URL {
        URL(string: thumbnail)!
    }

    var hasRemainingSpots: Bool {
        spots > 0
    }

    var remainingSpotsLabel: String {
        hasRemainingSpots ? "\(spots) spots remaining" : "No available spots"
    }
}

final class RoomListViewModel: ObservableObject {
    let title: String = "Book Your Room"

    @Published private(set) var rooms: [Room] = []

    // MARK: - Load Rooms

    @MainActor
    func loadRooms() async {
        let roomsEndPoint = URL(string: "https://wetransfer.github.io/rooms.json")!
        do {
            let (jsondata, _) = try await URLSession.shared.data(from: roomsEndPoint)
            let response = try JSONDecoder().decode(RoomsResponse.self, from: jsondata)
            self.rooms = response.rooms
        }
        catch {
            Log.networkActivity.log("Failed to load Rooms! Reason: \(error.localizedDescription)")
        }
    }

    @MainActor
    func loadSampleRooms() async {
        let response = await SampleDataFetcher().defaultRooms()
        self.rooms = response.rooms
    }

    func bookRoom(_ room: Room) {
        print("Room Booking Requested!")
    }
}


