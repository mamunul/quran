//
//  SurahDO+CoreDataProperties.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//
//

import Foundation
import CoreData


extension SurahDO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SurahDO> {
        return NSFetchRequest<SurahDO>(entityName: "SurahDO")
    }

    @NSManaged public var ayahCount: Int16
    @NSManaged public var firstAyahNo: Int16
    @NSManaged public var lastAyahNo: Int16
    @NSManaged public var name: String?
    @NSManaged public var revelaitonPlace: String?
    @NSManaged public var revelationOrder: Int16
    @NSManaged public var surahNo: Int16
    @NSManaged public var translationn: Bool

}

extension SurahDO : Identifiable {

}
