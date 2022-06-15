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

SQLiteConverter().readSurah()

class SQLiteConverter {
    private let basePath = "Documents/ios_workspace/htmlattributes/QuranAndSunnah/QuranAndSunnah/Resources/"
    private let jsonRepo = QuranJsonFacade()
    
    func readSurah() {
        jsonRepo.basePath = basePath
        let surah = jsonRepo.getSurah(contentID: .en_unknown)
        print(surah)
        
//        let surahTranslation = jsonRepo.getSurahTranslation(content: <#T##SurahNameID#>, language: <#T##Language#>)
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
                revelaitonPlace: RevelationPlace.meccan,
                contentID: .en_unknown
            )

        coredata.insert(surah: surah1)

        coredata.getSurah(contentID: .en_unknown)

        surah1 =
            Surah2(
                id: 0,
                surahNo: 0,
                ayahCount: 3,
                firstAyahNo: 4,
                lastAyahNo: 6,
                name: "safs",
                revelationOrder: 9,
                revelaitonPlace: RevelationPlace.meccan,
                contentID: .en_unknown
            )

        coredata.insert(surah: surah1)
        print(coredata.getSurah(contentID: .en_unknown))

    }
}
