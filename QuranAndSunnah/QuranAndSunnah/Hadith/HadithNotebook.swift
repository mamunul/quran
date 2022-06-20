//
//  Bookmark.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation
import SwiftUI

struct HadithTag: Codable {
    var tag: Tag
    var hadith: [HadithHighlight]
}

struct HadithPin: Codable { // doesnt require db - appstore is sufficient
    static let empty = HadithPin(hadithCollector: .none, hadithNo: 0, chapterNo: 0)
    var hadithCollector: HadithCollector
    var hadithNo: Int
    var chapterNo: Int
}

struct HadithNote: Codable {
    var note: String
    var range: Range<Int>
    var highlightedText: String
    var hadithNo: Int
    var chapterNo: Int

    var contentID: ContentIdentity<HadithContentID>
}

struct HadithHighlight: Codable {
    var range: Range<Int>
    var highlightedText: String
    var hadithNo: Int
    var chapterNo: Int

    var contentID: ContentIdentity<HadithContentID>
}

struct HadithBookmark: Codable {
    var hadithNo: Int
    var chapterNo: Int

    var contentID: ContentIdentity<HadithContentID>
}
