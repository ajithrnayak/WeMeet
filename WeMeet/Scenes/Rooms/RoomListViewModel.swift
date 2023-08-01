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

struct Room: Codable {
    let name: String
    let spots: Int
    let thumbnail: String
}

final class RoomListViewModel: ObservableObject {
    let title: String = "Book Your Room"

    func loadRooms() async {
        let roomsEndPoint = URL(string: "https://wetransfer.github.io/rooms.json")!
        do {
            let (jsondata, _) = try await URLSession.shared.data(from: roomsEndPoint)
            let rooms = try JSONDecoder().decode(RoomsResponse.self, from: jsondata)
            print(rooms)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
