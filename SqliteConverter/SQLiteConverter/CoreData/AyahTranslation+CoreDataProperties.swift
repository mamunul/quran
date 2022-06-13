//
//  AyahTranslation+CoreDataProperties.swift
//  SQLiteConverter
//
//  Created by Mamunul Mazid on 13/6/22.
//
//

import Foundation
import CoreData


extension AyahTranslation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AyahTranslation> {
        return NSFetchRequest<AyahTranslation>(entityName: "AyahTranslation")
    }

    @NSManaged public var text: String?
    @NSManaged public var contentId: Int16
    @NSManaged public var language: Int16
    @NSManaged public var translation: Bool
    @NSManaged public var ayahNo: Int16

}

extension AyahTranslation : Identifiable {

}
