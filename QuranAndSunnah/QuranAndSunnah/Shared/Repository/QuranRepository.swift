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

class QuranJsonFacade {
    static let shared = QuranJsonFacade()
    #if os(macOS)
        var basePath = ""
    #else
        private let basePath = ""
    #endif

    func getSurah() -> [Surah2] {
        let surahNammeTranslationJson = QuranRepository.shared.surahNameTranslations(basePath).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        let surahInfoJson = QuranRepository.shared.surahinfo(basePath).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var surahList = [Surah2]()

        for (surahInfo, surahName) in zip(surahInfoJson, surahNammeTranslationJson) {
            let surah =
                Surah2(
                    id: Int(surahName.key)!,
                    surahNo: Int(surahName.key)!,
                    ayahCount: surahInfo.value.nAyah,
                    firstAyahNo: surahInfo.value.start,
                    lastAyahNo: surahInfo.value.end,
                    name: surahInfo.value.name,
                    revelationOrder: surahInfo.value.revelationOrder,
                    revelaitonPlace: RevelationPlace(rawValue: surahInfo.value.type)!
                )

            surahList.append(surah)
        }
        return surahList
    }

    func getSurahTranslation(content: SurahNameID, language: Language) -> [SurahNameTranslation<SurahNameID>] {
        let surahNammeTranslationJson = QuranRepository.shared.surahNameTranslations(basePath).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }
        var surahTranslationList = [SurahNameTranslation<SurahNameID>]()

        for surahName in surahNammeTranslationJson {
            let translation =
                SurahNameTranslation<SurahNameID>(
                    contentID: SurahNameID.en_tanzil,
                    lang: .en,
                    text: surahName.value.translation,
                    surahNo: (surahName.key as NSString).integerValue
                )

            surahTranslationList.append(translation)
        }
        return surahTranslationList
    }

    func getSurahTransliteration(content: SurahNameID, language: Language) -> [SurahNameTranslation<SurahNameID>] {
        let surahNammeTranslationJson = QuranRepository.shared.surahNameTranslations(basePath).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var surahTransliterationList = [SurahNameTranslation<SurahNameID>]()

        for surahName in surahNammeTranslationJson {
            let transliteration =
                SurahNameTranslation<SurahNameID>(
                    contentID: SurahNameID.en_tanzil,
                    lang: .en,
                    text: surahName.value.name,
                    surahNo: (surahName.key as NSString).integerValue
                )

            surahTransliterationList.append(transliteration)
        }
        return surahTransliterationList
    }

    func getAyat(of surah: Surah2) -> [Ayah2] {
        let ayah = QuranRepository.shared.getAllAyah(basePath).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahList = [Ayah2]()

        for ayahAr in ayah {
            let ayah =
                Ayah2(
                    id: Int(ayahAr.key)!,
                    ayahNo: Int(ayahAr.key)!,
                    text: ayahAr.value,
                    bookmark: false,
                    language: .ar,
                    contentID: AyahContentID.content1
                )

            ayahList.append(ayah)
        }

        ayahList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }

    func getAyahTranslation(of surah: Surah2, content: QuranTranslationID, language: Language) -> [AyahTraslation<QuranTranslationID>] {
        let translationsJson = QuranRepository.shared.getAllTranslations(basePath).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahTranslationList = [AyahTraslation<QuranTranslationID>]()

        for ayahTranslation in translationsJson {
            let translation =
                AyahTraslation(
                    contentID: QuranTranslationID.en_hilali_quranenc,
                    lang: .en,
                    text: ayahTranslation.value,
                    ayahNo: (ayahTranslation.key as NSString).integerValue
                )
            ayahTranslationList.append(translation)
        }
        ayahTranslationList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahTranslationList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }

    func getAyahTransliterations(of surah: Surah2, content: QuranTranslationID, language: Language) -> [AyahTraslation<QuranTranslationID>] {
        let transliterationnJson = QuranRepository.shared.getAllAyahTransliterations(basePath).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahTransliterationList = [AyahTraslation<QuranTranslationID>]()

        for ayahTrannsliteration in transliterationnJson {
            let transliteration =
                AyahTraslation(
                    contentID: QuranTranslationID.id_litequran,
                    lang: .en,
                    text: ayahTrannsliteration.value,
                    ayahNo: surah.surahNo
                )

            ayahTransliterationList.append(transliteration)
        }
        ayahTransliterationList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahTransliterationList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }
}
