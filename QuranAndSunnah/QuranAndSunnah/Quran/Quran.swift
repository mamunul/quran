//
//  Quran.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

protocol ContentID: Equatable, Codable {
    func getFilePath() -> String

    func getTitle() -> String
    func getLanguage() -> Language
    func getContentType() -> ContentType
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

    func getTitle() -> String {
        switch self {
        case .en_hilali_quranenc:
            return "Hilali"
        case .en_itani_tanzil:
            return "Itani Tanzil"
        case .en_sarwar_tanzil:
            return "Sarwar Tanzil"
        case .bn_bengali_tanzil:
            return "Tanzil"
        case .transliteration_litequran:
            return "Lite"
        case .indonesia_ar:
            return "Indonesian"
        }
    }

    func getLanguage() -> Language {
        switch self {
        case .en_hilali_quranenc, .en_itani_tanzil, .en_sarwar_tanzil:
            return .en
        case .bn_bengali_tanzil:
            return .bn
        case .transliteration_litequran:
            return .en
        case .indonesia_ar:
            return .ar
        }
    }

    func getContentType() -> ContentType {
        switch self {
        case .en_hilali_quranenc, .en_itani_tanzil, .en_sarwar_tanzil, .bn_bengali_tanzil:
            return .translation
        case .transliteration_litequran:
            return .transliteration
        case .indonesia_ar:
            return .original
        }
    }
}

enum SurahNameContentID: Int, ContentID {
    func getTitle() -> String {
        switch self {
        case .en_unknown:
            return "Unknown"
        case .en_tanzil:
            return "Tanzil"
        }
    }

    func getLanguage() -> Language {
        switch self {
        case .en_unknown:
            return .ar
        case .en_tanzil:
            return .en
        }
    }

    func getContentType() -> ContentType { // this can be set
        switch self {
        case .en_unknown:
            return .original
        case .en_tanzil:
            return .translation
        }
    }

    // SurahNameContentID, SurahNameContentID should be one
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

struct SurahInfo: Codable, Identifiable, Equatable {
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
    func getTitle() -> String {
        switch self {
        case .en_wbw:
            return "en-wbw"
        case .bn_wbw:
            return "bn-wbw"
        case .en_qranwbw:
            return "Qen-quranwbw"
        }
    }

    func getLanguage() -> Language {
        switch self {
        case .en_wbw:
            return .en
        case .bn_wbw:
            return .bn
        case .en_qranwbw:
            return .en
        }
    }

    func getContentType() -> ContentType {
        switch self {
        case .en_wbw:
            return .translation
        case .bn_wbw:
            return .translation
        case .en_qranwbw:
            return .transliteration
        }
    }

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
