//
//  SurahInfoDO+CoreDataProperties.swift
//  QuranAndSunnah
//
//  Created by newone on 19/6/22.
//
//

import Foundation
import CoreData


extension SurahInfoDO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SurahInfoDO> {
        return NSFetchRequest<SurahInfoDO>(entityName: "SurahInfoDO")
    }

    @NSManaged public var ayahCount: Int16
    @NSManaged public var firstAyahNo: Int16
    @NSManaged public var lastAyahNo: Int16
    @NSManaged public var revelaitonPlace: String?
    @NSManaged public var revelationOrder: Int16
    @NSManaged public var surahNo: Int16

}

extension SurahInfoDO : Identifiable {

}
