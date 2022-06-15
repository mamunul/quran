//
//  QuranJsonFacade.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 15/6/22.
//

import Foundation

class QuranJsonFacade: IDataReadFacade { // TODO: -convert for loops to map
    static let shared = QuranJsonFacade()

    var basePath = "" // Note: - this is only necessary for macos otherwise statys empty
    private let repo = QuranRepository.shared

    func getSurah(contentID: SurahNameContentID) throws -> [Surah2] {
        let surahInfoJsonDict: [String: SurahJson] = try repo.getQuranData(basePath, contentId: contentID)

        let surahInfoJsonArray = surahInfoJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var surahList = [Surah2]()

        for surahInfo in surahInfoJsonArray {
            let surah =
                Surah2(
                    id: Int(surahInfo.key)!,
                    surahNo: Int(surahInfo.key)!,
                    ayahCount: surahInfo.value.nAyah,
                    firstAyahNo: surahInfo.value.start,
                    lastAyahNo: surahInfo.value.end,
                    name: surahInfo.value.name,
                    revelationOrder: surahInfo.value.revelationOrder,
                    revelaitonPlace: RevelationPlace(rawValue: surahInfo.value.type)!,
                    contentID: .en_unknown
                )

            surahList.append(surah)
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
        var surahTranslationList = [SurahNameTranslation<SurahTranslationID>]()

        for surahName in surahNammeTranslationJsonArray {
            let translation =
                SurahNameTranslation<SurahTranslationID>(
                    contentID: SurahTranslationID.en_tanzil,
                    lang: .en,
                    text: surahName.value.translation,
                    surahNo: (surahName.key as NSString).integerValue
                )

            surahTranslationList.append(translation)
        }
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

        var surahTransliterationList = [SurahNameTranslation<SurahTranslationID>]()

        for surahName in surahNammeTranslationJsonArray {
            let transliteration =
                SurahNameTranslation<SurahTranslationID>(
                    contentID: SurahTranslationID.en_tanzil,
                    lang: .en,
                    text: surahName.value.name,
                    surahNo: (surahName.key as NSString).integerValue
                )

            surahTransliterationList.append(transliteration)
        }
        return surahTransliterationList
    }

    func getAyat(of surah: Surah2, contentID: AyahContentID) throws -> [Ayah2] {
        let ayahDict: [String: String] = try repo.getQuranData(basePath, contentId: contentID)

        let ayahArray = ayahDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahList = [Ayah2]()

        for ayahAr in ayahArray {
            let ayah =
                Ayah2(
                    id: Int(ayahAr.key)!,
                    ayahNo: Int(ayahAr.key)!,
                    text: ayahAr.value,
                    bookmark: false,
                    language: .ar,
                    contentID: AyahContentID.indonesia_ar
                )

            ayahList.append(ayah)
        }

        ayahList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }

    func getAyahTranslation(of surah: Surah2, contentID: AyahTranslationID, language: Language) throws -> [AyahTraslation<AyahTranslationID>] {
        let translationsJson: TranslationJson = try repo.getQuranData(basePath, contentId: contentID)

        let translationsJsonArray = translationsJson.translations.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahTranslationList = [AyahTraslation<AyahTranslationID>]()

        for ayahTranslation in translationsJsonArray {
            let translation =
                AyahTraslation(
                    contentID: AyahTranslationID.en_hilali_quranenc,
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

    func getAyahTransliterations(of surah: Surah2, contentID: AyahTranslationID, language: Language) throws -> [AyahTraslation<AyahTranslationID>] {
        let transliterationnJsonDict: [String: String] = try repo.getQuranData(basePath, contentId: contentID)

        let transliterationnJsonArray = transliterationnJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahTransliterationList = [AyahTraslation<AyahTranslationID>]()

        for ayahTrannsliteration in transliterationnJsonArray {
            let transliteration =
                AyahTraslation(
                    contentID: AyahTranslationID.transliteration_litequran,
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
