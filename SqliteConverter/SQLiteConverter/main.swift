//
//  main.swift
//  SqliteConverter
//
//  Created by newone on 13/6/22.
//

import Foundation

// print("path:", basePath)
// let quran = SQLiteConverter().getQuran(basePath: basePath)
// print("No of Surah: ", quran.surah.count)

SQLiteConverter().setupCoreData()

class SQLiteConverter {
    private let basePath = "Documents/ios_workspace/htmlattributes/QuranAndSunnah/QuranAndSunnah/Resources/"
    private let reppo = QuranJsonFacade()
    func getQuran() {
        reppo.basePath = basePath
    }

    func setupCoreData() {
        let coredata = CoreDataFacade.shared
        var surah1 =
            Surah2(
                id: 0,
                surahNo: 0,
                ayahCount: 3,
                firstAyahNo: 4,
                lastAyahNo: 6,
                name: "safs",
                revelationOrder: 9,
                revelaitonPlace: RevelationPlace.meccan
            )

        coredata.insert(surah: surah1)

        coredata.getSurah()

        surah1 =
            Surah2(
                id: 0,
                surahNo: 0,
                ayahCount: 3,
                firstAyahNo: 4,
                lastAyahNo: 6,
                name: "safs",
                revelationOrder: 9,
                revelaitonPlace: RevelationPlace.meccan
            )

        coredata.insert(surah: surah1)
        print(coredata.getSurah())

    }
}
