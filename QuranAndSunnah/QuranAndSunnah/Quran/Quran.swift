//
//  Quran.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

protocol ContentID: Equatable, Decodable {
    func getFilePath() -> String
}

enum AyahTranslationID: Int, ContentID {
    case en_hilali_quranenc
    case en_itani_tanzil
    case en_sarwar_tanzil
    case bn_bengali_tanzil
    case transliteration_litequran

    func getFilePath() -> String {
        switch self {
        case .en_hilali_quranenc:
            return "Quran/ayah-translation/en-hilali-quranenc.json"
        case .en_itani_tanzil:
            return "Quran/ayah-translation/en-itani-tanzil.json"
        case .en_sarwar_tanzil:
            return "Quran/ayah-translation/en-sarwar-tanzil.json"
        case .bn_bengali_tanzil:
            return "Quran/ayah-translation/bn-bengali-tanzil.json"
        case .transliteration_litequran:
            return "Quran/ayah-transliteration/id-litequran.json"
        }
    }
}

enum SurahTranslationID: Int, ContentID {
    func getFilePath() -> String {
        switch self {
        case .en_tanzil:
            return "Quran/surah-translation/en-tanzil.json"
        }
    }

    case en_tanzil
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
    var contentID: SurahNameContentID
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

enum AyahContentID: Int, ContentID {
    func getFilePath() -> String {
        switch self {
        case .indonesia_ar:
            return "Quran/ayah-text/indonesia.json"
        }
    }

    case indonesia_ar
}

enum SurahNameContentID: Int, ContentID {
    func getFilePath() -> String {
        switch self {
        case .en_unknown:
            return "Quran/surah/surah.json"
        }
    }

    case en_unknown
}

enum Language: Int, Decodable {
    case en, bn, ar
}

struct TextContent<T: ContentID>: Decodable {
    var contentID: T
    var lang: Language
    var text: String
}

struct SurahNameTranslation<T: ContentID>: Decodable {
    var contentID: T
    var lang: Language
    var text: String
    var surahNo: Int
}

struct AyahTraslation<T: ContentID>: Decodable {
    var contentID: T
    var lang: Language
    var text: String
    var ayahNo: Int
}

enum WordContentID: Int, ContentID {
    case en_wbw, bn_wbw, en_qranwbw

    func getFilePath() -> String {
        switch self {
        case .en_wbw:
            return "Quran/word-translation/en-wbw.json"
        case .bn_wbw:
            return "Quran/word-translation/bn-wbw.json"
        case .en_qranwbw:
            return "Quran/word-transliteration/en-quranwbw.json"
        }
    }
}

struct Word<T: ContentID>: Decodable {
    var contentID: T
    var lang: Language
    var text: String
    var ayahNo: Int
    var wordNo: Int
}
