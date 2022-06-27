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
    private var repository = QuranJsonFacade.shared

    func getAyatTranslation() -> [Ayah] {
        var ayat = [Ayah]()
        do {
            let surahList = try repository.getSurah()

            ayat = try repository.getAllAyat(contentId: .en_hilali_quranenc, surahList: surahList)
        } catch {
            print(error)
        }
        return ayat
    }
}
