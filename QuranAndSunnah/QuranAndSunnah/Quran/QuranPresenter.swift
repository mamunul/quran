//
//  QuranPresenter.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import Foundation

class QuranPresenter: ObservableObject {
    @Published var quran: Quran = Quran(surah: [])
    @Published var surah: Surah?
    private var repository = QuranRepository.shared
    func getQuran() {
        let quran = repository.requestQuran()
        self.quran = quran
        surah = quran.surah.first
    }
}
