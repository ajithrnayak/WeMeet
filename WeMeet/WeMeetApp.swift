//
//  WeMeetApp.swift
//  WeMeet
//
//  Created by Ajith Renjala on 01/08/23.
//

import SwiftUI

@main
struct WeMeetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
