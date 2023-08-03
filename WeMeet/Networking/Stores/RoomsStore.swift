//
//  RoomsStore.swift
//  WeMeet
//
//  Created by Ajith Renjala on 03/08/23.
//

import Foundation

public final class RoomsStore: StoreRepresentable {
    public typealias Endpoint = RoomsEndpoint

    public var networkClient: NetworkClient<RoomsEndpoint>
    public var persistenceStore: PersistenceStore

    public init(
        networkClient: NetworkClient<RoomsEndpoint> = NetworkClient<RoomsEndpoint>(),
        persistenceStore: PersistenceStore = PersistenceStore.shared
    ) {
        self.networkClient = networkClient
        self.persistenceStore = persistenceStore
    }

    public func fetchMeetingRooms() async throws {
        // first prepare context & decoder
        let taskContext = persistenceStore.makeBackgroundTaskContext()
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = taskContext
        // fetch and parse response
        let response: RoomsResponse = try await networkClient.performDataRequest(
            .meetingRoomsList, decoder: decoder
        )
        // save context
        persistenceStore.saveContext(taskContext)
        Log.networkActivity.info("Meeting Rooms:\(String(describing: response))")
    }

    public func performRoomBooking(for roomID: String) async throws -> Bool {
        let response: BookRoomResponse = try await networkClient.performDataRequest(
            .bookRoom(roomID: roomID)
        )
        return response.success
    }
}
