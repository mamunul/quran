//
//  Bookmark.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation
import SwiftUI

struct QuranTag: Codable {
    var tag: Tag
    var ayat: [QuranBookmark]
}

struct QuranPin: Codable { // same for tafsir; doesnt require db - @appstorage is sufficient
    static let empty = QuranPin(ayah: Ayah.empty)
    var ayah: Ayah
}

struct QuranNote: Codable {
    var note: String
    var range: Range<Int>
    var highlightedText: String
    var ayatNo: Int
    var surahNo: Int

    var contentId: ContentIdentity<AyahContentID>
}

struct QuranHighlight: Codable {
    var range: ClosedRange<Int>
    var highlightedText: String
    var ayatNo: Int
    var surahNo: Int

    var contentId: ContentIdentity<AyahContentID>
}

struct QuranBookmark: Codable {
    var ayatNo: Int
    var surahNo: Int
    var contentId: ContentIdentity<AyahContentID>
}
