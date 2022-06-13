//
//  QuranRepository.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 1/6/22.
//

import Foundation

protocol ContentID: Equatable, Decodable {
}

enum QuranTranslationID: ContentID {
    case indonesia_ar
    case en_hilali_quranenc
    case en_itani_tanzil
    case en_sarwar_tanzil
    case bn_bengali_tanzil
    case id_litequran
}

enum SurahNameID: ContentID {
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

    private var quran: Quran?

    func requestQuran(basePath: String = "") -> Quran {
        if quran != nil {
            return quran!
        }
        let surahNameTranslationPath = "Quran/surah-translation/en-tanzil.json"
        #if os(iOS)
            let surahNameTranslationUrl = Bundle.main.url(forResource: surahNameTranslationPath, withExtension: "")!
        #else
            let surahNameTranslationUrl = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("\(basePath)\(surahNameTranslationPath)")
        #endif
        let surahNammeTranslationJson = surahNameTranslations(surahNameTranslationUrl).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        let surahInfoPath = "Quran/surah/surah.json"
        #if os(iOS)
            let surahInfoUrl = Bundle.main.url(forResource: surahInfoPath, withExtension: "")!
        #else
            let surahInfoUrl = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("\(basePath)\(surahInfoPath)")
        #endif

        let surahInfoJson = surahinfo(surahInfoUrl).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }
        let ayatTranslationPath = "Quran/ayah-translation/en-hilali-quranenc.json"
        #if os(iOS)
            let ayatTranslationUrl = Bundle.main.url(forResource: ayatTranslationPath, withExtension: "")!
        #else
            let ayatTranslationUrl = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("\(basePath)\(ayatTranslationPath)")
        #endif

        let translationsJson = getAllTranslations(ayatTranslationUrl).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }
        let ayatTransliterationPath = "Quran/ayah-transliteration/id-litequran.json"
        #if os(iOS)
            let ayatTransliterationUrl = Bundle.main.url(forResource: ayatTransliterationPath, withExtension: "")!
        #else
            let ayatTransliterationUrl = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("\(basePath)\(ayatTransliterationPath)")
        #endif

        let transliterationnJson = getAllAyahTransliterations(ayatTransliterationUrl).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }
//        let transliterationnJson = getAllAyahTransliterations()
        let sarabicAyatPath = "Quran/ayah-text/indonesia.json"
        #if os(iOS)
            let arabicAyatUrl = Bundle.main.url(forResource: sarabicAyatPath, withExtension: "")!
        #else
            let arabicAyatUrl = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("\(basePath)\(sarabicAyatPath)")
        #endif

        let ayah = getAllAyah(arabicAyatUrl).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahList = [Ayah]()

        for (ayahAr, (ayahTranslation, ayahTrannsliteration)) in zip(ayah, zip(translationsJson, transliterationnJson)) {
            let translation = TextContent(contentID: QuranTranslationID.en_hilali_quranenc, lang: .en, text: ayahTranslation.value)
            let transliteration = TextContent(contentID: QuranTranslationID.id_litequran, lang: .en, text: ayahTrannsliteration.value)
            let ayah =
                Ayah(
                    id: Int(ayahAr.key)!,
                    ayahNo: Int(ayahAr.key)!,
                    arabic: ayahAr.value,
                    translations: [translation],
                    transliterations: [transliteration],
                    words: [Word](),
                    bookmark: false,
                    tags: [String]()
                )

            ayahList.append(ayah)
        }

        ayahList.sort { $0.ayahNo < $1.ayahNo }

        var surahList = [Surah]()

        for (surahInfo, surahName) in zip(surahInfoJson, surahNammeTranslationJson) {
            let translation = TextContent<SurahNameID>(contentID: SurahNameID.en_tanzil, lang: .en, text: surahName.value.translation)
            let transliteration = TextContent<SurahNameID>(contentID: SurahNameID.en_tanzil, lang: .en, text: surahName.value.name)

            let ayat = Array(ayahList[surahInfo.value.start - 1 ... surahInfo.value.end - 1])
            let surah =
                Surah(
                    id: Int(surahName.key)!,
                    surahNo: Int(surahName.key)!,
                    ayahCount: surahInfo.value.nAyah,
                    firstAyahNo: surahInfo.value.start,
                    lastAyahNo: surahInfo.value.end,
                    name: surahInfo.value.name,
                    nameTranslations: [translation],
                    nameTransliterations: [transliteration],
                    revelationOrder: surahInfo.value.revelationOrder,
                    revelaitonPlace: Surah.RevelationPlace(rawValue: surahInfo.value.type)!,
                    ayat: ayat)

            surahList.append(surah)
        }

        quran = Quran(surah: surahList)
        return quran!
    }

    func surahNameTranslations(_ surahNameTranslationUrl: URL) -> [String: SurahTranslationJson] {
        do {
            let data = try Data(contentsOf: surahNameTranslationUrl)
            let res = try JSONDecoder().decode([String: SurahTranslationJson].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func surahinfo(_ surahInfoUrl: URL) -> [String: SurahJson] {
        do {
            let data = try Data(contentsOf: surahInfoUrl)
            let res = try JSONDecoder().decode([String: SurahJson].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllTranslations(_ ayatTranslationnUrl: URL) -> [String: String] {
        do {
            let data = try Data(contentsOf: ayatTranslationnUrl)
            let res = try JSONDecoder().decode(TranslationJson.self, from: data)
            return res.translations
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllAyahTransliterations(_ ayatTransliterationUrl: URL) -> [String: String] {
        do {
            let data = try Data(contentsOf: ayatTransliterationUrl)
            let res = try JSONDecoder().decode([String: String].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllAyah(_ arabicAyatUrl: URL) -> [String: String] {
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
