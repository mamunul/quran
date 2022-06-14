//
//  SurahTranslationDO+CoreDataProperties.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//
//

import Foundation
import CoreData


extension SurahTranslationDO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SurahTranslationDO> {
        return NSFetchRequest<SurahTranslationDO>(entityName: "SurahTranslationDO")
    }

    @NSManaged public var contentId: Int16
    @NSManaged public var language: Int16
    @NSManaged public var surahNo: Int16
    @NSManaged public var text: String?
    @NSManaged public var translation: Bool

}

extension SurahTranslationDO : Identifiable {

}
