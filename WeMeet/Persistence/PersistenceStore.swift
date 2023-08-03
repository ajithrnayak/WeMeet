//
//  Persistence.swift
//  WeMeet
//
//  Created by Ajith Renjala on 01/08/23.
//

import CoreData

public struct PersistenceStore {
    public static let shared = PersistenceStore()
    public let container: NSPersistentContainer
    public let mainQueueContext: NSManagedObjectContext

    private init() {
        container = NSPersistentContainer(name: "WeMeet")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        // setup main queue's context
        mainQueueContext = container.viewContext
        mainQueueContext.stalenessInterval = 0
        mainQueueContext.automaticallyMergesChangesFromParent = true
        mainQueueContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    public func makeBackgroundTaskContext() -> NSManagedObjectContext {
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.stalenessInterval = 0
        return taskContext
    }
}

public extension PersistenceStore {
    static var preview: PersistenceStore = PersistenceStore()
}
