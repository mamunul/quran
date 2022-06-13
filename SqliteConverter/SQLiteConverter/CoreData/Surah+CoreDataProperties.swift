//
//  Surah+CoreDataProperties.swift
//  SQLiteConverter
//
//  Created by Mamunul Mazid on 13/6/22.
//
//

import Foundation
import CoreData


extension Surah {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Surah> {
        return NSFetchRequest<Surah>(entityName: "Surah")
    }

    @NSManaged public var surahNo: Int16
    @NSManaged public var ayahCount: Int16
    @NSManaged public var firstAyahNo: Int16
    @NSManaged public var lastAyahNo: Int16
    @NSManaged public var revelationOrder: Int16
    @NSManaged public var revelaitonPlace: Int16
    @NSManaged public var name: String?

}

extension Surah : Identifiable {

}
