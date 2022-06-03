//
//  HadithPresenter.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import Foundation

class HadithPresenter: ObservableObject {
    @Published var collectors = [HadithCollector]()

    func getHadithCollectorList() {
        collectors = HadithRepository().getCollectorList()
    }

    func getHadith(of collector: HadithCollector) -> HadithBook {
        let book = HadithRepository().getHadith(of: collector)
        return book
    }
}
