//
//  QuranJsonFacade.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 15/6/22.
//

import Foundation

class QuranJsonFacade: IDataReadFacade {
    static let shared = QuranJsonFacade()

    var basePath = "" // Note: - this is only necessary for macos otherwise statys empty
    private let repo = QuranRepository.shared

    func getSurah(contentID: SurahNameContentID) throws -> [Surah2] {
        let surahInfoJsonDict: [String: SurahJson] = try repo.getQuranData(basePath, contentId: contentID)

        let surahInfoJsonArray = surahInfoJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        let surahList = surahInfoJsonArray.map { (key: String, value: SurahJson) in
            Surah2(
                id: Int(key)!,
                surahNo: Int(key)!,
                ayahCount: value.nAyah,
                firstAyahNo: value.start,
                lastAyahNo: value.end,
                name: value.name,
                revelationOrder: value.revelationOrder,
                revelaitonPlace: RevelationPlace(rawValue: value.type)!,
                contentID: .en_unknown
            )
        }
        return surahList
    }

    func getSurahTranslation(
        contentID: SurahTranslationID,
        language: Language
    ) throws -> [SurahNameTranslation<SurahTranslationID>] {
        let surahNammeTranslationJsonDict: [String: SurahTranslationJson] =
            try repo.getQuranData(basePath, contentId: contentID)

        let surahNammeTranslationJsonArray = surahNammeTranslationJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        let surahTranslationList = surahNammeTranslationJsonArray.map({ (key: String, value: SurahTranslationJson) in
            SurahNameTranslation<SurahTranslationID>(
                contentID: SurahTranslationID.en_tanzil,
                lang: .en,
                text: value.translation,
                surahNo: (key as NSString).integerValue
            )
        })

        return surahTranslationList
    }

    func getSurahTransliteration(
        contentID: SurahTranslationID,
        language: Language
    ) throws -> [SurahNameTranslation<SurahTranslationID>] {
        let surahNammeTranslationJsonDict: [String: SurahTranslationJson] =
            try repo.getQuranData(basePath, contentId: contentID)

        let surahNammeTranslationJsonArray = surahNammeTranslationJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        let surahTransliterationList = surahNammeTranslationJsonArray.map { (key: String, value: SurahTranslationJson) in

            SurahNameTranslation<SurahTranslationID>(
                contentID: SurahTranslationID.en_tanzil,
                lang: .en,
                text: value.name,
                surahNo: (key as NSString).integerValue
            )
        }

        return surahTransliterationList
    }

    func getAyat(of surah: Surah2, contentID: AyahContentID) throws -> [Ayah2] {
        let ayahDict: [String: String] = try repo.getQuranData(basePath, contentId: contentID)

        let ayahArray = ayahDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahList = ayahArray.map { (key: String, value: String) in
            Ayah2(
                id: Int(key)!,
                ayahNo: Int(key)!,
                text: value,
                bookmark: false,
                language: .ar,
                contentID: AyahContentID.indonesia_ar
            )
        }

        ayahList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }

    func getAyahTranslation(of surah: Surah2, contentID: AyahTranslationID, language: Language) throws
        -> [AyahTraslation<AyahTranslationID>] {
        let translationsJson: TranslationJson = try repo.getQuranData(basePath, contentId: contentID)

        let translationsJsonArray = translationsJson.translations.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahTranslationList = translationsJsonArray.map { (key: String, value: String) in
            AyahTraslation(
                contentID: AyahTranslationID.en_hilali_quranenc,
                lang: .en,
                text: value,
                ayahNo: (key as NSString).integerValue
            )
        }
        ayahTranslationList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahTranslationList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }

    func getAyahTransliterations(of surah: Surah2, contentID: AyahTranslationID, language: Language) throws
        -> [AyahTraslation<AyahTranslationID>] {
        let transliterationnJsonDict: [String: String] = try repo.getQuranData(basePath, contentId: contentID)

        let transliterationnJsonArray = transliterationnJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahTransliterationList = transliterationnJsonArray.map { (key: String, value: String) in
            AyahTraslation(
                contentID: AyahTranslationID.transliteration_litequran,
                lang: .en,
                text: value,
                ayahNo: (key as NSString).integerValue
            )
        }
        ayahTransliterationList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahTransliterationList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }
}
