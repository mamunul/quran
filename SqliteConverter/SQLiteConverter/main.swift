//
//  main.swift
//  SqliteConverter
//
//  Created by newone on 13/6/22.
//

import Foundation

let basePath = "Documents/ios_workspace/htmlattributes/QuranAndSunnah/QuranAndSunnah/Resources/"
print("path:", basePath)
let quran = SQLiteConverter().getQuran(basePath: basePath)
print("No of Surah: ", quran.surah.count)

class SQLiteConverter {
    private let controller = PersistenceController()
    private let reppo = QuranRepository.shared
    func getQuran(basePath: String) -> Quran {
        let quran = reppo.requestQuran(basePath: basePath)
        return quran
    }

    func setupCoreData() {
    }
}
