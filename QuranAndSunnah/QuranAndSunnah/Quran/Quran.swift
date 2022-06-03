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
    var nameTranslations: [Translation]
    var nameTransliterations: [Transliteration]
    var revelationOrder: Int
    var revelaitonPlace: RevelationPlace
    var ayat: [Ayah]
}

enum Language {
    case en, bn, ar
}

struct Translation {
    var lang: Language
    var translation: String
}

struct Transliteration {
    var lang: Language
    var transliteration: String
}

struct Word {
    var wordNo: Int
    var translations: [Translation]
    var transliterations: [Transliteration]
}

struct Ayah: Identifiable {
    var id: Int
    var ayahNo: Int
    var arabic: String
    var translations: [Translation]
    var transliterations: [Transliteration]
    var words: [Word]
    var bookmark: Bool
    var tags: [String]
}
