//
//  WeMeetApp.swift
//  WeMeet
//
//  Created by Ajith Renjala on 01/08/23.
//

import SwiftUI

@main
struct WeMeetApp: App {
    let persistenceStore = PersistenceStore.shared

    var body: some Scene {
        WindowGroup {
            RoomListView(viewModel: RoomListViewModel())
                .environment(
                    \.managedObjectContext,
                     persistenceStore.mainQueueContext
                )
        }
    }
}
