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

struct Surah {
    enum RevelationPlace {
        case madina, mecca
    }

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

struct Ayah {
    var ayahNo: Int
    var arabic: String
    var translations: [Translation]
    var transliterations: [Transliteration]
    var words: [Word]
    var bookmark: Bool
    var tags: [String]
}
