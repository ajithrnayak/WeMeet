//
//  RoomListViewModel.swift
//  WeMeet
//
//  Created by Ajith Renjala on 01/08/23.
//

import Foundation

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

extension Room {
    static var example: Room {
        Room(
            name: "Taj Mahal",
            spots: 1,
            thumbnail: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Taj-Mahal.jpg/1600px-Taj-Mahal.jpg"
        )
    }
}

struct AlertConfig {
    let title: String
    let message: String
}

final class RoomListViewModel: ObservableObject {
    let title: String = "Book Your Room"

    @Published private(set) var rooms: [Room]
    @Published var isLoading: Bool
    @Published var showLoadingOverlay: Bool
    @Published var isAlertVisible: Bool

    var alertConfig: AlertConfig? = nil

    // MARK: - Init

    init(rooms: [Room] = [],
         isLoading: Bool = false,
         showLoadingOverlay: Bool = false,
         isAlertVisible: Bool = false) {
        self.rooms = rooms
        self.isLoading = isLoading
        self.showLoadingOverlay = showLoadingOverlay
        self.isAlertVisible = isAlertVisible
        // initiate data refresh without waiting for view to appear
        loadRooms()
    }

    // MARK: - Load Rooms
    func loadRooms() {
        isLoading = true
        Task { @MainActor in
            await loadSampleRooms()
            isLoading = false
        }
    }

    @MainActor
    func fetchRooms() async {
        let roomsEndPoint = URL(string: "https://wetransfer.github.io/rooms.json")!
        do {
            let (jsondata, _) = try await URLSession.shared.data(from: roomsEndPoint)
            let response = try JSONDecoder().decode(RoomsResponse.self, from: jsondata)
            self.rooms = response.rooms
        }
        catch {
            Log.networkActivity.error("Failed to load Rooms! Reason: \(error.localizedDescription)")
        }
    }

    @MainActor
    func loadSampleRooms() async {
        let response = await SampleDataFetcher().defaultRooms()
        self.rooms = response.rooms
    }

    func bookRoom(_ room: Room) {
        showLoadingOverlay = true
        Log.userActivity.info("Room Booking Requested!")
        Task { @MainActor in
            do {
                let isBookingSuccess = try await requestRoomBooking()
                showLoadingOverlay = false
                handleRoomBookingStatus(isBookingSuccess)
            }
            catch {
                Log.networkActivity.error("Booking Failed! \(error.localizedDescription)")
                showLoadingOverlay = false
                handleRoomBookingStatus(false)
            }
        }
    }

    private func handleRoomBookingStatus(_ isSuccess: Bool) {
        let title = isSuccess ? "Booking Successful!" : "Booking Failed"
        let msg = isSuccess ?
        "Thank you! Your booking is successful. Enjoy your stay with us!" :
        "Failed to process this booking. Please try again later."
        let alertConfig = AlertConfig(title: title, message: msg)
        self.alertConfig = alertConfig
        self.isAlertVisible = true
    }

    func requestRoomBooking() async throws -> Bool {
        let bookRoomEndpoint = URL(string: "https://wetransfer.github.io/bookRoom.json")!
        let (data, _) = try await URLSession.shared.data(from: bookRoomEndpoint)
        let response = try JSONDecoder().decode(BookRoomResponse.self, from: data)
        return response.success
    }
}

extension RoomListViewModel {
    static var example: RoomListViewModel {
        let response: RoomsResponse = load("Rooms.json")
        return RoomListViewModel(rooms: response.rooms)
    }
}
