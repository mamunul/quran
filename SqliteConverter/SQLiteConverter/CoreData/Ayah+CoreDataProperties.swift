//
//  Ayah+CoreDataProperties.swift
//  SQLiteConverter
//
//  Created by Mamunul Mazid on 13/6/22.
//
//

import Foundation
import CoreData


extension Ayah {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ayah> {
        return NSFetchRequest<Ayah>(entityName: "Ayah")
    }

    @NSManaged public var ayahNo: Int16
    @NSManaged public var text: String?
    @NSManaged public var contentId: Int16
    @NSManaged public var bookmark: Bool

}

extension Ayah : Identifiable {

}
