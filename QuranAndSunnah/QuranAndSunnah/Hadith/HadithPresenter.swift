//
//  HadithPresenter.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import Foundation

class HadithPresenter: ObservableObject {
    @Published var collectors = [HadithCollector]()
    private var repo = HadithRepository()
    func getHadithCollectorList() {
        collectors = repo.getCollectorList()
    }

    func getHadithList(of chapter: HadithChapter, collector: HadithCollector) -> [Hadith] {
        do {
            let list = try repo.getHadithList(of: chapter, collector: collector)
            return list
        } catch {
            print(error)
            return []
        }
    }

    func getHadithBook(of collector: HadithCollector) -> HadithBook {
        do {
            let book = try repo.getHadith(of: collector)
            return book
        } catch {
            print(error)
        }
        return HadithBook.empty
    }
}
