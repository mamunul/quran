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

    func getSurah(contentID: SurahNameContentID) -> [Surah2] {
        let surahInfoJson = repo.surahinfo(basePath, contentId: contentID).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var surahList = [Surah2]()

        for surahInfo in surahInfoJson {
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
    ) -> [SurahNameTranslation<SurahTranslationID>] {
        let surahNammeTranslationJson =
            repo.surahNameTranslations(basePath, contentId: contentID).sorted { left, right in
                Int(left.key)! < Int(right.key)!
            }
        var surahTranslationList = [SurahNameTranslation<SurahTranslationID>]()

        for surahName in surahNammeTranslationJson {
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
    ) -> [SurahNameTranslation<SurahTranslationID>] {
        let surahNammeTranslationJson =
            repo.surahNameTranslations(basePath, contentId: contentID).sorted { left, right in
                Int(left.key)! < Int(right.key)!
            }

        var surahTransliterationList = [SurahNameTranslation<SurahTranslationID>]()

        for surahName in surahNammeTranslationJson {
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

    func getAyat(of surah: Surah2, contentID: AyahContentID) -> [Ayah2] {
        let ayah = repo.getAllAyah(basePath, contentId: contentID).sorted { left, right in
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

    func getAyahTranslation(of surah: Surah2, contentID: AyahTranslationID, language: Language) -> [AyahTraslation<AyahTranslationID>] {
        let translationsJson = repo.getAllAyahTranslations(basePath, contentId: contentID).sorted { left, right in
            Int(left.key)! < Int(right.key)!
        }

        var ayahTranslationList = [AyahTraslation<AyahTranslationID>]()

        for ayahTranslation in translationsJson {
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

    func getAyahTransliterations(of surah: Surah2, contentID: AyahTranslationID, language: Language) -> [AyahTraslation<AyahTranslationID>] {
        let transliterationnJson =
            repo.getAllAyahTransliterations(basePath, contentId: contentID).sorted { left, right in
                Int(left.key)! < Int(right.key)!
            }

        var ayahTransliterationList = [AyahTraslation<AyahTranslationID>]()

        for ayahTrannsliteration in transliterationnJson {
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
