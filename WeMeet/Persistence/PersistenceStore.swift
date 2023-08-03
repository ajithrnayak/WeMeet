//
//  Persistence.swift
//  WeMeet
//
//  Created by Ajith Renjala on 01/08/23.
//

import CoreData

public enum PersistenceStoreError: Error {
    case saveFailed(Error)
}

public class PersistenceStore {
    public static let shared = PersistenceStore()
    public let container: NSPersistentContainer
    public let mainQueueContext: NSManagedObjectContext

    private init() {
        container = NSPersistentContainer(name: "WeMeet")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            Log.dbActivity.info("Persistence Store: \(storeDescription)")
        }
        // setup main queue's context
        mainQueueContext = container.viewContext
        mainQueueContext.stalenessInterval = 0
        mainQueueContext.automaticallyMergesChangesFromParent = true
        mainQueueContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Child Context
    public func makeChildViewContext() -> NSManagedObjectContext {
        let childViewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childViewContext.parent = container.viewContext
        childViewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        childViewContext.stalenessInterval = 0
        return childViewContext
    }

    // MARK: - Task Context

    public func makeBackgroundTaskContext() -> NSManagedObjectContext {
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.stalenessInterval = 0
        registerForContextSaveNotification(context: taskContext)
        return taskContext
    }

    private func registerForContextSaveNotification(
        context: NSManagedObjectContext
    ) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.backgroundTaskContextDidSave(_:)),
            name: NSNotification.Name.NSManagedObjectContextDidSave,
            object: context
        )
    }

    @objc
    private func backgroundTaskContextDidSave(_ note: Notification) {
      mainQueueContext.mergeChanges(fromContextDidSave: note)
    }

    // MARK: - Default Configs

    public static var defaultBatchSize: Int {
      return 20
    }
}

// MARK: - Write

public extension PersistenceStore {
    func saveContext(
        _ context: NSManagedObjectContext,
        mergeToParent: Bool = true
    ) {
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
            if (mergeToParent && context.parent != nil) {
                try context.parent?.save()
            }
        } catch {
            Log.dbActivity.error("Failed to write changes to DB. Reason: \(error)")
        }
    }

    func writeChanges(
        _ changes: @escaping (NSManagedObjectContext) -> Void,
        inContext context: NSManagedObjectContext,
        mergeToParent: Bool = true
    ) {
        Task {
            do {
                try await context.perform {
                    // invokes on context's queue
                    changes(context)

                    try context.save()
                    if (mergeToParent && context.parent != nil) {
                        try context.parent?.save()
                    }
                }
            } catch {
                Log.dbActivity.error("Failed to write changes to DB. Reason: \(error)")
            }
        }
    }
}

public extension PersistenceStore {
    static var preview: PersistenceStore = PersistenceStore()
}
