//
//  Word+CoreDataProperties.swift
//  SQLiteConverter
//
//  Created by Mamunul Mazid on 13/6/22.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var wordNo: Int16
    @NSManaged public var text: String?
    @NSManaged public var language: Int16
    @NSManaged public var contentId: Int16
    @NSManaged public var ayahNo: Int16

}

extension Word : Identifiable {

}
