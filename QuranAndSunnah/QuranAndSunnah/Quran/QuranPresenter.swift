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
    private var repository = QuranRepository()
    func getQuran() {
        DispatchQueue.global().async { [self] in
            let quran = self.repository.requestQuran()
            DispatchQueue.main.async {
                self.quran = quran
                self.surah = quran.surah.first
            }
        }
    }
}
