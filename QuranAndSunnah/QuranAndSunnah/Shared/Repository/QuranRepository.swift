//
//  QuranRepository.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 1/6/22.
//

import Foundation

protocol ContentID: Equatable, Decodable {
}

enum QuranTranslationID: Int, ContentID {
    case indonesia_ar
    case en_hilali_quranenc
    case en_itani_tanzil
    case en_sarwar_tanzil
    case bn_bengali_tanzil
    case id_litequran
}

enum SurahNameID: Int, ContentID {
    case en_tanzil
}

class QuranRepository {
    static let shared = QuranRepository()
    let arabicAyah = "indonesia.json"

    let englishTranslation1 = "ayah-translation/en-hilali-quranenc.json"
    let englishTranslation2 = "ayah-translation/en-sarwar-tanzil.json"
    let englishTranslation3 = "ayah-translation/en-itani-tanzil.json"
    let banglaTranslation1 = "ayah-translation/bn-bengali-tanzil.json"
    let englishTransliteration = "ayah-transliteration/id-litequran.json"
    let surahTranslation = "surah-translation/en-tanzil.json"
    let surahInfo = "surah/surah.json"
    let wordEnglishTranslation = "word-translation/en-wbw.json"
    let wordBanglaTranslation = "word-translation/bn-wbw.json"
    let wordEnglishTransliteration = "word-transliteration/en-quranwbw.json"

    private init() {}

//    private var quran: Quran?
    #if os(macOS)
        private let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
    #endif

    func surahNameTranslations(_ basePath: String) -> [String: SurahTranslationJson] {
        let surahNameTranslationPath = "Quran/surah-translation/en-tanzil.json"
        #if os(iOS)
            let surahNameTranslationUrl = Bundle.main.url(forResource: surahNameTranslationPath, withExtension: "")!
        #else
            let surahNameTranslationUrl = homeDirectory.appendingPathComponent("\(basePath)\(surahNameTranslationPath)")
        #endif
        do {
            let data = try Data(contentsOf: surahNameTranslationUrl)
            let res = try JSONDecoder().decode([String: SurahTranslationJson].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func surahinfo(_ basePath: String) -> [String: SurahJson] {
        let surahInfoPath = "Quran/surah/surah.json"
        #if os(iOS)
            let surahInfoUrl = Bundle.main.url(forResource: surahInfoPath, withExtension: "")!
        #else
            let surahInfoUrl = homeDirectory.appendingPathComponent("\(basePath)\(surahInfoPath)")
        #endif
        do {
            let data = try Data(contentsOf: surahInfoUrl)
            let res = try JSONDecoder().decode([String: SurahJson].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllTranslations(_ basePath: String) -> [String: String] {
        let ayatTranslationPath = "Quran/ayah-translation/en-hilali-quranenc.json"
        #if os(iOS)
            let ayatTranslationUrl = Bundle.main.url(forResource: ayatTranslationPath, withExtension: "")!
        #else
            let ayatTranslationUrl = homeDirectory.appendingPathComponent("\(basePath)\(ayatTranslationPath)")
        #endif
        do {
            let data = try Data(contentsOf: ayatTranslationUrl)
            let res = try JSONDecoder().decode(TranslationJson.self, from: data)
            return res.translations
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllAyahTransliterations(_ basePath: String) -> [String: String] {
        let ayatTransliterationPath = "Quran/ayah-transliteration/id-litequran.json"
        #if os(iOS)
            let ayatTransliterationUrl = Bundle.main.url(forResource: ayatTransliterationPath, withExtension: "")!
        #else
            let ayatTransliterationUrl = homeDirectory.appendingPathComponent("\(basePath)\(ayatTransliterationPath)")
        #endif
        do {
            let data = try Data(contentsOf: ayatTransliterationUrl)
            let res = try JSONDecoder().decode([String: String].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllAyah(_ basePath: String) -> [String: String] {
        let sarabicAyatPath = "Quran/ayah-text/indonesia.json"
        #if os(iOS)
            let arabicAyatUrl = Bundle.main.url(forResource: sarabicAyatPath, withExtension: "")!
        #else
            let arabicAyatUrl = homeDirectory.appendingPathComponent("\(basePath)\(sarabicAyatPath)")
        #endif
        do {
            let data = try Data(contentsOf: arabicAyatUrl)
            let res = try JSONDecoder().decode([String: String].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }
}

struct TranslationJson: Decodable {
    var translations: [String: String]
}

struct SurahJson: Decodable {
    var name: String
    var nAyah: Int
    var revelationOrder: Int
    var type: String
    var start: Int
    var end: Int
}

struct SurahTranslationJson: Decodable {
    var name: String
    var translation: String
}
