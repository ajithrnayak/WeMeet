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
}

final class RoomListViewModel: ObservableObject {
    let title: String = "Book Your Room"

    @Published private(set) var rooms: [Room] = []

    // MARK: - Load Rooms

    func loadRooms() async {
        let roomsEndPoint = URL(string: "https://wetransfer.github.io/rooms.json")!
        do {
            let (jsondata, _) = try await URLSession.shared.data(from: roomsEndPoint)
            let response = try JSONDecoder().decode(RoomsResponse.self, from: jsondata)
            self.rooms = response.rooms
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
