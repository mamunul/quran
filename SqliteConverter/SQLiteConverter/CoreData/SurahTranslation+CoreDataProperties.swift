//
//  SurahTranslation+CoreDataProperties.swift
//  SQLiteConverter
//
//  Created by Mamunul Mazid on 13/6/22.
//
//

import Foundation
import CoreData


extension SurahTranslation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SurahTranslation> {
        return NSFetchRequest<SurahTranslation>(entityName: "SurahTranslation")
    }

    @NSManaged public var text: String?
    @NSManaged public var surahNo: Int16
    @NSManaged public var contentId: Int16
    @NSManaged public var language: Int16
    @NSManaged public var translation: Bool

}

extension SurahTranslation : Identifiable {

}
