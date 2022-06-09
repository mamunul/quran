//
//  Quran.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct Quran {
    var surah: [Surah]
}

struct Surah: Identifiable {
    enum RevelationPlace: String {
        case medinan, meccan
    }

    var id: Int
    var surahNo: Int
    var ayahCount: Int
    var firstAyahNo: Int
    var lastAyahNo: Int
    var name: String
    var nameTranslations: [TextContent]
    var nameTransliterations: [TextContent]
    var revelationOrder: Int
    var revelaitonPlace: RevelationPlace
    var ayat: [Ayah]
}

enum Language {
    case en, bn, ar
}

struct TextContent {
    var contentID: ContentID
    var lang: Language
    var text: String
}

struct Word {
    var contentID: ContentID
    var translations: [TextContent]
    var transliterations: [TextContent]
}

struct Ayah: Identifiable {
    var id: Int
    var ayahNo: Int
    var arabic: String
    var translations: [TextContent]
    var transliterations: [TextContent]
    var words: [Word]
    var bookmark: Bool
    var tags: [String]
}
