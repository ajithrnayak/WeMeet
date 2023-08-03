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
        networkClient: NetworkClient<RoomsEndpoint>,
        persistenceStore: PersistenceStore
    ) {
        self.networkClient = networkClient
        self.persistenceStore = persistenceStore
    }

    public func fetchRooms() {

    }
}
