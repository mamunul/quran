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
        let surahList = repository.getSurah(contentID: .en_unknown)
        self.surahList = surahList
        surah = surahList.first
    }
    
    func getSurahTransliterationList() {
        let surahList = repository.getSurahTransliteration(contentID: .en_tanzil, language: .en)
        
        let dict = surahList.reduce(into: [Int: SurahNameTranslation<SurahTranslationID>]()) {
            $0[$1.surahNo] = $1
        }
        self.surahTranslilerationList = dict
    }
    
    func getSurahTranslationList() {
        let surahList = repository.getSurahTranslation(contentID: .en_tanzil, language: .en)
        
        let dict = surahList.reduce(into: [Int: SurahNameTranslation<SurahTranslationID>]()) {
            $0[$1.surahNo] = $1
        }
        self.surahTranslationList = dict
    }

    func getAyat(of surah: Surah2) -> [Ayah2] {
        let ayahList = repository.getAyat(of: surah, contentID: .indonesia_ar)
        return ayahList
    }

    func getAyatTranslation(of surah: Surah2) -> [Int: AyahTraslation<AyahTranslationID>] {
        let ayahList = repository.getAyahTranslation(of: surah, contentID: .en_hilali_quranenc, language: .en)

        let dict = ayahList.reduce(into: [Int: AyahTraslation<AyahTranslationID>]()) {
            $0[$1.ayahNo] = $1
        }

        return dict
    }
}
