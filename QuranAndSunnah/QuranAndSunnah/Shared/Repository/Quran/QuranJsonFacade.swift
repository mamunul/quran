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
    private let repo = QuranJSONParser.shared

    func getSurah() throws -> [SurahInfo] {
        let surahInfoJsonDict: [String: SurahJson] = try repo.getQuranData(basePath, contentId: SurahNameContentID.en_unknown)

        let surahInfoJsonArray = surahInfoJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        let surahList = surahInfoJsonArray.map { (key: String, value: SurahJson) in
            SurahInfo(
                id: Int(key)!,
                surahNo: Int(key)!,
                ayahCount: value.nAyah,
                firstAyahNo: value.start,
                lastAyahNo: value.end,
                revelationOrder: value.revelationOrder,
                revelaitonPlace: RevelationPlace(rawValue: value.type)!
            )
        }
        return surahList
    }

    func getSurahArabic(contentId: SurahNameContentID) throws -> [SurahName] {
        let surahInfoJsonDict: [String: SurahJson] = try repo.getQuranData(basePath, contentId: contentId)

        let surahInfoJsonArray = surahInfoJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        let surahList = surahInfoJsonArray.map { (key: String, value: SurahJson) in
            SurahName(
                text: value.name,
                surahNo: (key as NSString).integerValue,
                contentId: ContentIdentity<SurahNameContentID>(
                    contentId: SurahNameContentID.en_unknown,
                    lang: .ar,
                    contentType: .original)
            )
        }
        return surahList
    }

    func getSurahTranslation(
        contentId: SurahNameContentID,
        language: Language
    ) throws -> [SurahName] {
        let surahNammeTranslationJsonDict: [String: SurahTranslationJson] =
            try repo.getQuranData(basePath, contentId: contentId)

        let surahNammeTranslationJsonArray = surahNammeTranslationJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        let surahTranslationList = surahNammeTranslationJsonArray.map({ (key: String, value: SurahTranslationJson) in
            SurahName(
                text: value.translation,
                surahNo: (key as NSString).integerValue,
                contentId: ContentIdentity<SurahNameContentID>(
                    contentId: SurahNameContentID.en_tanzil,
                    lang: .en,
                    contentType: .translation
                )
            )
        })

        return surahTranslationList
    }

    func getSurahTransliteration(
        contentId: SurahNameContentID,
        language: Language
    ) throws -> [SurahName] {
        let surahNammeTranslationJsonDict: [String: SurahTranslationJson] =
            try repo.getQuranData(basePath, contentId: contentId)

        let surahNammeTranslationJsonArray = surahNammeTranslationJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        let surahTransliterationList = surahNammeTranslationJsonArray.map { (key: String, value: SurahTranslationJson) in

            SurahName(
                text: value.name,
                surahNo: (key as NSString).integerValue,
                contentId: ContentIdentity<SurahNameContentID>(
                    contentId: SurahNameContentID.en_tanzil,
                    lang: .en,
                    contentType: .transliteration)
            )
        }

        return surahTransliterationList
    }

    func getAyat(of surah: SurahInfo, contentId: AyahContentID) throws -> [Ayah] {
        let ayahDict: [String: String] = try repo.getQuranData(basePath, contentId: contentId)

        let ayahArray = ayahDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahList = ayahArray.map { (key: String, value: String) in
            Ayah(
                id: Int(key)!,
                text: value,
                ayahNo: Int(key)!,
                surahNo: surah.surahNo,
                contentId: ContentIdentity<AyahContentID>(
                    contentId: AyahContentID.indonesia_ar,
                    lang: .ar,
                    contentType: .original)
            )
        }

        ayahList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }

    func getAllAyat(contentId: AyahContentID, surahList: [SurahInfo]) throws -> [Ayah] {
        let translationsJson: TranslationJson = try repo.getQuranData(basePath, contentId: contentId)

        let translationsJsonArray = translationsJson.translations.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }
        var ayahList = [Ayah]()
        var surahNo = 1
        for (key, value) in translationsJsonArray {
            let ayah = Ayah(
                id: (key as NSString).integerValue,
                text: value,
                ayahNo: (key as NSString).integerValue,
                surahNo: surahNo,
                contentId: ContentIdentity<AyahContentID>(
                    contentId: AyahContentID.en_hilali_quranenc,
                    lang: .en,
                    contentType: .translation)
            )
            ayahList.append(ayah)

            if surahList[surahNo].lastAyahNo == ayah.ayahNo {
                surahNo += 1
            }
        }

        return ayahList
    }

    func getAyahTranslation(of surah: SurahInfo, contentId: AyahContentID, language: Language) throws
        -> [Ayah] {
        let translationsJson: TranslationJson = try repo.getQuranData(basePath, contentId: contentId)

        let translationsJsonArray = translationsJson.translations.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahTranslationList = translationsJsonArray.map { (key: String, value: String) in
            Ayah(
                id: (key as NSString).integerValue,
                text: value,
                ayahNo: (key as NSString).integerValue,
                surahNo: surah.surahNo,
                contentId: ContentIdentity<AyahContentID>(
                    contentId: AyahContentID.en_hilali_quranenc,
                    lang: .en,
                    contentType: .translation)
            )
        }
        ayahTranslationList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahTranslationList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }

    func getAyahTransliteration(of surah: SurahInfo, contentId: AyahContentID, language: Language) throws
        -> [Ayah] {
        let transliterationnJsonDict: [String: String] = try repo.getQuranData(basePath, contentId: contentId)

        let transliterationnJsonArray = transliterationnJsonDict.sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahTransliterationList = transliterationnJsonArray.map { (key: String, value: String) in
            Ayah(
                id: (key as NSString).integerValue,
                text: value,
                ayahNo: (key as NSString).integerValue,
                surahNo: surah.surahNo,
                contentId: ContentIdentity<AyahContentID>(
                    contentId: AyahContentID.transliteration_litequran,
                    lang: .en,
                    contentType: .transliteration)
            )
        }
        ayahTransliterationList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahTransliterationList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }
}
