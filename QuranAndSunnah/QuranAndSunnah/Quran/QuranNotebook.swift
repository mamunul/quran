//
//  Bookmark.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation
import SwiftUI

struct QuranTag {
    var tag: Tag
    var ayat: [QuranBookmark]
}

struct QuranPin { // same for tafsir; doesnt require db - @appstorage is sufficient
    static let empty = QuranPin(ayah: Ayah.empty)
    var ayah: Ayah
}
struct QuranNote {
    var note: String
    var range: Range<Int>
    var highlightedText: String
    var ayatNo: Int

    var contentID: ContentIdentity<AyahContentID>
}
struct QuranHighlight {
    var range: Range<Int>
    var highlightedText: String
    var ayatNo: Int

    var contentID: ContentIdentity<AyahContentID>
}
struct QuranBookmark {
    var ayatNo: Int

    var contentID: ContentIdentity<AyahContentID>
}
