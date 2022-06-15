//
//  QuranJsonFacade.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 15/6/22.
//

import Foundation

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
                    revelaitonPlace: RevelationPlace(rawValue: surahInfo.value.type)!,
                    contentID: .en_unknown
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
                    contentID: AyahContentID.indonesia_ar
                )

            ayahList.append(ayah)
        }

        ayahList.sort { $0.ayahNo < $1.ayahNo }

        let ayat = Array(ayahList[surah.firstAyahNo - 1 ... surah.lastAyahNo - 1])
        return ayat
    }

    func getAyahTranslation(of surah: Surah2, content: QuranTranslationID, language: Language) -> [AyahTraslation<QuranTranslationID>] {
        let translationsJson = QuranRepository.shared.getAllAyahTranslations(basePath).sorted { left, right in
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
                    contentID: QuranTranslationID.transliteration_litequran,
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
