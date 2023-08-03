//
//  StoreRepresentable.swift
//  WeMeet
//
//  Created by Ajith Renjala on 03/08/23.
//

import Foundation

/**
 Use to configure a store that handles fetching data from network and persisting it in db
 */
public protocol StoreRepresentable {
    associatedtype Endpoint: EndpointConfigurable

    var networkClient: NetworkClient<Endpoint> { get set }
    var persistenceStore: PersistenceStore { get set }

    init(
        networkClient: NetworkClient<Endpoint>,
        persistenceStore: PersistenceStore
    )
}
