//
//  Quran.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct Quran: Decodable {
    var surah: [Surah]
}

struct Surah2: Decodable, Identifiable {
    var id: Int
    var surahNo: Int
    var ayahCount: Int
    var firstAyahNo: Int
    var lastAyahNo: Int
    var name: String
    var revelationOrder: Int
    var revelaitonPlace: RevelationPlace
}

struct Ayah2: Decodable, Identifiable {
    var id: Int
    var ayahNo: Int
    var text: String
    var bookmark: Bool
    var language: Language
    var contentID: AyahContentID
}

enum RevelationPlace: String, Decodable {
    case medinan, meccan
}

enum AyahContentID: ContentID {
    case content1
}

struct Surah: Decodable, Identifiable {
    var id: Int
    var surahNo: Int
    var ayahCount: Int
    var firstAyahNo: Int
    var lastAyahNo: Int
    var name: String
    var nameTranslations: [TextContent<SurahNameID>]
    var nameTransliterations: [TextContent<SurahNameID>]
    var revelationOrder: Int
    var revelaitonPlace: RevelationPlace
    var ayat: [Ayah]
}

enum Language: Int, Decodable {
    case en, bn, ar
}

struct TextContent<T: ContentID>: Decodable {
    var contentID: T
    var lang: Language
    var text: String
}

struct Word<T: ContentID>: Decodable {
    var contentID: T
    var translations: [TextContent<QuranTranslationID>]
    var transliterations: [TextContent<QuranTranslationID>]
}

struct Ayah: Decodable, Identifiable {
    var id: Int
    var ayahNo: Int
    var arabic: String
    var translations: [TextContent<QuranTranslationID>]
    var transliterations: [TextContent<QuranTranslationID>]
    var words: [Word<QuranTranslationID>]
    var bookmark: Bool
    var tags: [String]
}
