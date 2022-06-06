//
//  HadithPresenter.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import Foundation

class HadithPresenter: ObservableObject {
    @Published var collectors = [HadithCollector]()
    @Published var hadithBook: HadithBook = .empty
    private var repo = HadithRepository()
    func getHadithCollectorList() {
        collectors = repo.getCollectorList()
    }

    func getHadith(of collector: HadithCollector) {
        DispatchQueue.global().async {
            let book = self.repo.getHadith(of: collector)
            DispatchQueue.main.async {
                self.hadithBook = book
            }
        }
    }
}
