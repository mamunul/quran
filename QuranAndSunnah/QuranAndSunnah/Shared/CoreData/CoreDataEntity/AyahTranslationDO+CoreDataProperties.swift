//
//  AyahTranslationDO+CoreDataProperties.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//
//

import Foundation
import CoreData


extension AyahTranslationDO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AyahTranslationDO> {
        return NSFetchRequest<AyahTranslationDO>(entityName: "AyahTranslationDO")
    }

    @NSManaged public var ayahNo: Int16
    @NSManaged public var contentId: Int16
    @NSManaged public var language: Int16
    @NSManaged public var text: String?
    @NSManaged public var translation: Bool

}

extension AyahTranslationDO : Identifiable {

}
