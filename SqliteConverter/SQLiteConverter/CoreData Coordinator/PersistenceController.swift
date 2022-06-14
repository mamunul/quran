//
//  Persistence.swift
//  t2
//
//  Created by newone on 12/6/22.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    var container: NSPersistentContainer?
//    var context: NSManagedObjectContext?

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
        container?.loadPersistentStores(completionHandler: { description, error in
            print(description, error as Any)
        })
    }

    func writeData(contents: [Decodable]) {
        do {
            for index in 20 ... 30 {
                let object = NSManagedObject(entity: entity!, insertInto: container?.viewContext)

                object.setValue(Int16(index), forKey: "hundred")

                container?.viewContext.insert(object)
                try object.managedObjectContext?.save()
            }
            saveContext()
        } catch {
            print(error)
        }
    }

    func readSchema() {
        let entities = container?.managedObjectModel.entities

        for ent in entities! {
            print(ent.name as Any)
            print(ent.attributeKeys)
            print(ent.propertiesByName)
        }
    }

    func read() {
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CounterTable")

        print(container?.viewContext.insertedObjects.count as Any)

        do {
            let fetchedEmployees = try container?.viewContext.fetch(employeesFetch) as! [NSManagedObject]

            for object in fetchedEmployees {
                for key in object.entity.attributeKeys {
                    print(key, object.value(forKey: key) as Any)
                }
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
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

    private var entity: NSEntityDescription?
}
