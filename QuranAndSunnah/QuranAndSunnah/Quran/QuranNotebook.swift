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

protocol IHighlight {
    var range: ClosedRange<Int> { get set }
    var highlightedText: String { get set }
}

struct QuranHighlight: IHighlight, Codable {
    var range: ClosedRange<Int>
    var highlightedText: String
    var ayatNo: Int
    var surahNo: Int

    var contentId: ContentIdentity<AyahContentID>
}

struct QuranBookmark: Identifiable, Equatable, Codable {
    static func == (lhs: QuranBookmark, rhs: QuranBookmark) -> Bool {
        lhs.id == rhs.id
    }

    static let empty =
        QuranBookmark(
            ayatNo: 0,
            surahNo: 0,
            contentId: ContentIdentity<AyahContentID>(
                contentId: .bn_bengali_tanzil,
                lang: .ar,
                contentType: .original
            )
        )
    var id = UUID()
    var ayatNo: Int
    var surahNo: Int
    var contentId: ContentIdentity<AyahContentID>
}
