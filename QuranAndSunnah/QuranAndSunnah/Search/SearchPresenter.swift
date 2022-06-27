//
//  SearchPresenter.swift
//  QuranAndSunnah
//
//  Created by newone on 27/6/22.
//

import Foundation

enum SearchType: String {
    case hadith, quran, tafsir, all
}

class SearchPresenter: ObservableObject {
    @Published var searchSelection = SearchType.quran
    @Published var searchString = ""
    private var repository = QuranJsonFacade.shared
    private var hadithRepository = HadithRepository()

    private var hadithList = [HadithText]()
    private var ayat = [Ayah]()

    func getHadithList() -> [HadithText] {
        if !hadithList.isEmpty {
            return hadithList
        }
        var allList = [HadithText]()
        do {
            let collector = hadithRepository.getCollectorList()
            allList = try hadithRepository.getAllHadith(of: collector)
        } catch {
            print(error)
        }
        hadithList = allList
        return allList
    }

    func getAyatTranslation() -> [Ayah] {
        if !ayat.isEmpty {
            return ayat
        }
        var ayat = [Ayah]()
        do {
            let surahList = try repository.getSurah()

            ayat = try repository.getAllAyat(contentId: .en_hilali_quranenc, surahList: surahList)
        } catch {
            print(error)
        }
        self.ayat = ayat
        return ayat
    }
}
