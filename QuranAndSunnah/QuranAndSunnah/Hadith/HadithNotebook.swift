//
//  Bookmark.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation
import SwiftUI

struct HadithTag {
    var tag: Tag
    var hadith: [HadithHighlight]
}

struct HadithPin { // doesnt require db - appstore is sufficient
    static let empty = HadithPin(hadithCollector: .none, hadith: HadithText.empty)
    var hadithCollector: HadithCollector
    var hadith: HadithText
}

struct HadithNote {
    var note: String
    var range: Range<Int>
    var highlightedText: String
    var hadithNo: Int

    var contentID: ContentIdentity<HadithContentID>
}

struct HadithHighlight {
    var range: Range<Int>
    var highlightedText: String
    var hadithNo: Int

    var contentID: ContentIdentity<HadithContentID>
}

struct HadithBookmark {
    var hadithNo: Int

    var contentID: ContentIdentity<HadithContentID>
}
