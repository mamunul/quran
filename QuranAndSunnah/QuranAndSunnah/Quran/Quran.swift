//
//  Quran.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

protocol ContentID: Equatable, Codable {
    func getFilePath() -> String
}

struct ContentIdentity<T: ContentID>: Codable {
    var contentId: T
    var lang: Language
    var contentType: ContentType
}

enum AyahContentID: Int, ContentID {
    case en_hilali_quranenc
    case en_itani_tanzil
    case en_sarwar_tanzil
    case bn_bengali_tanzil
    case transliteration_litequran
    case indonesia_ar

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
        case .indonesia_ar:
            return "Quran/ayah-text/indonesia.json"
        }
    }
}

enum SurahNameContentID: Int, ContentID { // SurahNameContentID, SurahNameContentID should be one
    func getFilePath() -> String {
        switch self {
        case .en_unknown:
            return "Quran/surah/surah.json"
        case .en_tanzil:
            return "Quran/surah-translation/en-tanzil.json"
        }
    }

    case en_unknown
    case en_tanzil
}

struct SurahInfo: Codable, Identifiable {
    var id: Int
    var surahNo: Int
    var ayahCount: Int
    var firstAyahNo: Int
    var lastAyahNo: Int
    var revelationOrder: Int
    var revelaitonPlace: RevelationPlace
}

struct SurahName: Codable {
    var text: String
    var surahNo: Int

    var contentId: ContentIdentity<SurahNameContentID>
}

enum ContentType: Int, Codable {
    case translation, transliteration, original
}

struct Ayah: Codable, Identifiable {
    static let empty = Ayah(
        id: 0,
        text: "",
        ayahNo: 0,
        surahNo: 0,
        contentId: ContentIdentity<AyahContentID>(
            contentId: .transliteration_litequran,
            lang: .en,
            contentType: .translation
        )
    )
    var id: Int
    var text: String
    var ayahNo: Int
    var surahNo: Int

    var contentId: ContentIdentity<AyahContentID>
}

enum RevelationPlace: String, Codable {
    case medinan, meccan
}

enum Language: Int, Codable {
    case en, bn, ar
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

struct Word<T: ContentID>: Codable {
    var contentId: T
    var lang: Language
    var text: String
    var ayahNo: Int
    var wordNo: Int
}
