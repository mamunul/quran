//
//  Persistence.swift
//  t2
//
//  Created by newone on 12/6/22.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    private var container: NSPersistentContainer?
//    var context: NSManagedObjectContext?

    private init() {
    }

    func setupDatabase(name: String, blueprint: Decodable) {
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: "\(name).sql", relativeTo: dirURL)!


        container = NSPersistentContainer(name: name)
        do {
            _ = try container?.persistentStoreCoordinator.addPersistentStore(type: .sqlite, configuration: nil, at: fileURL, options: nil)
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
    
    private func createSurahEntity(){
        
    }
    
    private func createAyahEntity(){
        
    }
    
    private func createAyahTranslationEntity(){
        
    }
    
    private func createAyahTransliterationEntity(){
        
    }
    
    private func createSurahTranslationEntity(){
        
    }
}


func cast<T>(value: Any) -> T? {
    return value as? T
}
