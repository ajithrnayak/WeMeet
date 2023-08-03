//
//  StoreRepresentable.swift
//  WeMeet
//
//  Created by Ajith Renjala on 03/08/23.
//

import Foundation

public protocol StoreRepresentable {
    associatedtype Endpoint: EndpointConfigurable

    var networkClient: NetworkClient<Endpoint> { get set }
    var persistenceStore: PersistenceStore { get set }

    init(
        networkClient: NetworkClient<Endpoint>,
        persistenceStore: PersistenceStore
    )
}
