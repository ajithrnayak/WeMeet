//
//  RoomListViewModel.swift
//  WeMeet
//
//  Created by Ajith Renjala on 01/08/23.
//

import Foundation

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

    private let roomsStore: RoomsStore = RoomsStore()

    // MARK: - Init

    init(rooms: [Room] = [],
         isLoading: Bool = false,
         showLoadingOverlay: Bool = false,
         isAlertVisible: Bool = false) {
        self.rooms = rooms
        self.isLoading = isLoading
        self.showLoadingOverlay = showLoadingOverlay
        self.isAlertVisible = isAlertVisible
        // load data from db first
        loadRooms()
        // then, initiate data refresh without waiting for view to appear
        fetchRooms()
    }

    // MARK: - Load Rooms
    func loadRooms() {
        isLoading = true
        Task { @MainActor in
            //await loadSampleRooms()
            isLoading = false
        }
    }

    func fetchRooms() {
        Task {
            do {
                try await roomsStore.fetchMeetingRooms()
            }
            catch {
                Log.networkActivity.error("Failed to fetch Rooms! Reason: \(error.localizedDescription)")
            }
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
        try await roomsStore.performRoomBooking(for: "")
    }
}

extension RoomListViewModel {
    static var example: RoomListViewModel {
        let response: RoomsResponse = load("Rooms.json")
        return RoomListViewModel(rooms: response.rooms)
    }
}
