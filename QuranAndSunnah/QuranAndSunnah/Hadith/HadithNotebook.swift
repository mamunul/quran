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

    var contentId: ContentIdentity<HadithContentID>
}

struct HadithHighlight: IHighlight, Codable {
    var id = UUID()
    var range: ClosedRange<Int>
    var highlightedText: String
    var hadithNo: Int
    var chapterNo: Int

    var contentId: ContentIdentity<HadithContentID>
}

struct HadithBookmark: Equatable, Codable {
    static func == (lhs: HadithBookmark, rhs: HadithBookmark) -> Bool {
        lhs.id == rhs.id
    }

    static let empty =
        HadithBookmark(
            hadithNo: 0,
            chapterNo: 0,
            contentId: ContentIdentity<HadithContentID>(
                contentId: .abudaud_1,
                lang: .ar,
                contentType: .original
            )
        )
    var id = UUID()
    var hadithNo: Int
    var chapterNo: Int

    var contentId: ContentIdentity<HadithContentID>
}
