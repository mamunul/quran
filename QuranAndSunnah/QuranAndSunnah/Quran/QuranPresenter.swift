//
//  QuranPresenter.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import Foundation

class QuranPresenter: ObservableObject {
    @Published var surahList = [Surah2]()
    @Published var surahTranslationList = [Int: SurahNameTranslation<SurahTranslationID>]()
    @Published var surahTranslilerationList = [Int: SurahNameTranslation<SurahTranslationID>]()
    @Published var surah: Surah2?
    private var repository = QuranJsonFacade.shared

    func getSurahList() {
        do {
            let surahList = try repository.getSurah(contentID: .en_unknown)
            self.surahList = surahList
            surah = surahList.first
        } catch {
            print(error)
        }
    }

    func getSurahTransliterationList() {
        do {
            let surahList = try repository.getSurahTransliteration(contentID: .en_tanzil, language: .en)

            let dict = surahList.reduce(into: [Int: SurahNameTranslation<SurahTranslationID>]()) {
                $0[$1.surahNo] = $1
            }
            surahTranslilerationList = dict
        } catch {
            print(error)
        }
    }

    func getSurahTranslationList() {
        do {
            let surahList = try repository.getSurahTranslation(contentID: .en_tanzil, language: .en)

            let dict = surahList.reduce(into: [Int: SurahNameTranslation<SurahTranslationID>]()) {
                $0[$1.surahNo] = $1
            }
            surahTranslationList = dict
        } catch {
            print(error)
        }
    }

    func getAyat(of surah: Surah2) -> [Ayah2] {
        do {
            let ayahList = try repository.getAyat(of: surah, contentID: .indonesia_ar)
            return ayahList
        } catch {
            print(error)
        }
        return []
    }

    func getAyatTranslation(of surah: Surah2) -> [Int: AyahTraslation<AyahTranslationID>] {
        do {
            let ayahList = try repository.getAyahTranslation(of: surah, contentID: .en_hilali_quranenc, language: .en)

            let dict = ayahList.reduce(into: [Int: AyahTraslation<AyahTranslationID>]()) {
                $0[$1.ayahNo] = $1
            }

            return dict
        } catch {
            print(error)
        }
        return [:]
    }
}
