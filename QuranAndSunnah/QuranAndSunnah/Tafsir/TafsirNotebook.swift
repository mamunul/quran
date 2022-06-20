//
//  Bookmark.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation
import SwiftUI

struct Tag {
    var text: String
    var id: Int
}

struct TafsirTag {
    var tag: Tag
    var tafsirAyat: [TafsirHighlight]
}

struct TafsirHighlight {
    var range: Range<Int>
    var highlightedText: String
    var tafsirAyah: TafsirAyah
}

struct TafsirNote {
    var note: String
    var range: Range<Int>
    var highlightedText: String

    var tafsirAyah: TafsirAyah
}

struct TafsirPin { // same for tafsir; doesnt require db - @appstorage is sufficient
    static let empty = TafsirPin(ayah: TafsirAyah.empty, position: 0)
    var ayah: TafsirAyah
    var position: Int
}
