//
//  SurahNameDO+CoreDataProperties.swift
//  QuranAndSunnah
//
//  Created by newone on 19/6/22.
//
//

import Foundation
import CoreData


extension SurahNameDO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SurahNameDO> {
        return NSFetchRequest<SurahNameDO>(entityName: "SurahNameDO")
    }

    @NSManaged public var contentId: Int16
    @NSManaged public var contentType: Int16
    @NSManaged public var language: Int16
    @NSManaged public var surahNo: Int16
    @NSManaged public var text: String?

}

extension SurahNameDO : Identifiable {

}
