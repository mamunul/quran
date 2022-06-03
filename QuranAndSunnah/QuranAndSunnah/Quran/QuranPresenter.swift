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

    func getQuran() {
        let quran = QuranRepository().requestQuran()
        self.quran = quran
        surah = quran.surah.first
    }
}
