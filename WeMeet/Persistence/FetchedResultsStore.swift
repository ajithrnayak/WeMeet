//
//  FetchedResultsStore.swift
//  WeMeet
//
//  Created by Ajith Renjala on 03/08/23.
//

import CoreData

/// Read more here: https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-project/
final class FetchedResultsStore<Object: NSManagedObject>:
    NSObject,
    ObservableObject,
    NSFetchedResultsControllerDelegate {

    @Published var objects: [Object] = []
    private let fetchedResultsController: NSFetchedResultsController<Object>

    init(
        context: NSManagedObjectContext,
        predicate: NSPredicate?,
        sort: [NSSortDescriptor]?
    ) {
        // make fetch request
        let fetchRequest = NSFetchRequest<Object>(entityName: Object.entityName)
        fetchRequest.includesPendingChanges = true
        fetchRequest.fetchBatchSize = PersistenceStore.defaultBatchSize
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sort

        // make fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest, managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        // Listen to changes actively
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            self.objects = fetchedResultsController.fetchedObjects ?? []
        } catch {
            Log.dbActivity.error("failed to fetch items! Reason: \(error)")
        }
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        guard let objects = controller.fetchedObjects as? [Object] else {
            return
        }
        self.objects = objects
    }
}

extension NSManagedObject {
    public static var entityName: String {
        return String(describing: self)
    }
}
