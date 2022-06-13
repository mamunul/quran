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

    func setupDatabase<T: Decodable>(name: String, blueprint: T.Type) {
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: "\(name).sql", relativeTo: dirURL)!

        let momd = createDBSchema(blueprint)
        container = NSPersistentContainer(name: name, managedObjectModel: momd)
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

    private func createDBSchema(_ blueprint: Decodable.Type) -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // Create the entity
        entity = NSEntityDescription()
        let entityName = String(describing: blueprint.self)
//        print(stringMirror.subjectType)
        entity?.name = entityName
//        entity?.managedObjectClassName = "CounterTable"

        let mirror = Mirror(reflecting: blueprint)// this works on instance

        for child in mirror.children {
            let t = type(of: child.value)
            print(child.label, child.value, t)
        }

        // Create the attributes
        var properties = Array<NSAttributeDescription>()

        let remoteURLAttribute = NSAttributeDescription()
        remoteURLAttribute.name = "hundred"
        remoteURLAttribute.attributeType = .integer16AttributeType
        remoteURLAttribute.isOptional = false
        properties.append(remoteURLAttribute)

        // Add attributes to entity
        entity?.properties = properties

        // Add entity to model
        model.entities = [entity!]

        let indexDescription1 = NSFetchIndexElementDescription(property: remoteURLAttribute, collationType: .binary)
        indexDescription1.isAscending = true
        let index1 = NSFetchIndexDescription(name: "com_mc_index_post_createdDate", elements: [indexDescription1])

        entity?.indexes = [index1]
        entity?.renamingIdentifier = "com.mc.entity-post"

        return model
    }
}
