//
//  Persistence.swift
//  t2
//
//  Created by newone on 12/6/22.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    private var container: NSPersistentContainer?
    var mainContext: NSManagedObjectContext?
    var privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    private init() {
        setupDatabase(name: "QuranDM")
    }

    func setupDatabase(name: String) {
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let storeURL = URL(string: "\(name).sql", relativeTo: dirURL)!

        guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print("error")
            return
        }

        container = NSPersistentContainer(name: name, managedObjectModel: model)
        do {
            _ = try container?.persistentStoreCoordinator.addPersistentStore(type: .sqlite, configuration: nil, at: storeURL, options: nil)
        } catch {
            print(error)
        }
//        container?.loadPersistentStores(completionHandler: { description, error in
//            print(description, error as Any)
//        })
        
        privateContext.persistentStoreCoordinator = container?.persistentStoreCoordinator
        mainContext = container?.viewContext
    }

    func saveContext() {
        let context = container?.viewContext
        if context?.hasChanges ?? false {
            do {
                try context?.save()
            } catch {
                print(error)
            }
        }
    }
}
