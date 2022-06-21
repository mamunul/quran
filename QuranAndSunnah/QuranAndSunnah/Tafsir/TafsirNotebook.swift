//
//  Bookmark.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation
import SwiftUI

struct Tag: Codable {
    var text: String
    var id: Int
}

struct TafsirTag: Codable {
    var tag: Tag
    var tafsirAyat: [TafsirHighlight]
}

struct TafsirHighlight: Codable {
    var range: ClosedRange<Int>
    var highlightedText: String
    var tafsirAyah: TafsirAyah
    var surahNo: Int
}

struct TafsirNote: Codable {
    var note: String
    var range: ClosedRange<Int>
    var highlightedText: String
    var surahNo: Int

    var tafsirAyah: TafsirAyah
}

struct TafsirPin: Codable { // same for tafsir; doesnt require db - @appstorage is sufficient
    static let empty = TafsirPin(ayah: TafsirAyah.empty, surahNo: 0, position: 0)
    var ayah: TafsirAyah
    var surahNo: Int
    var position: Int
}
