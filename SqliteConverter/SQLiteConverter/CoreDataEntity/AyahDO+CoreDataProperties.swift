//
//  AyahDO+CoreDataProperties.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//
//

import Foundation
import CoreData


extension AyahDO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AyahDO> {
        return NSFetchRequest<AyahDO>(entityName: "AyahDO")
    }

    @NSManaged public var ayahNo: Int16
    @NSManaged public var bookmark: Bool
    @NSManaged public var contentId: Int16
    @NSManaged public var text: String?

}

extension AyahDO : Identifiable {

}
