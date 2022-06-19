//
//  WordDO+CoreDataProperties.swift
//  QuranAndSunnah
//
//  Created by newone on 19/6/22.
//
//

import Foundation
import CoreData


extension WordDO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordDO> {
        return NSFetchRequest<WordDO>(entityName: "WordDO")
    }

    @NSManaged public var ayahNo: Int16
    @NSManaged public var contentId: Int16
    @NSManaged public var language: Int16
    @NSManaged public var text: String?
    @NSManaged public var translation: Bool
    @NSManaged public var wordNo: Int16

}

extension WordDO : Identifiable {

}
