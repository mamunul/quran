//
//  main.swift
//  SqliteConverter
//
//  Created by newone on 13/6/22.
//

import Foundation

SQLiteConverter().insertAllQuranData()

class SQLiteConverter {
    private let basePath = "Documents/ios_workspace/htmlattributes/QuranAndSunnah/QuranAndSunnah/Resources/"
    private let jsonRepo = QuranJsonFacade()
    private let coredata = CoreDataFacade.shared
    var showLog = false

    init() {
        jsonRepo.basePath = basePath
    }

    func insertAllQuranData() {
        insertSurahFromJsonToSQLite()
        insertSurahTranslationFromJsonToSQLite()
        insertSurahTransliterationFromJsonToSQLite()
        insertAyatOfAllSurah()
    }

    func insertSurahFromJsonToSQLite() {
        do {
            let surah = try jsonRepo.getSurah()
            coredata.insert(surah: surah)
            if showLog {
                let ss = try coredata.getSurah()
                print(ss)
            }
        } catch {
            print(error)
        }
    }

    func insertSurahTranslationFromJsonToSQLite() {
        do {
            let surahTranslation = try jsonRepo.getSurahTranslation(contentId: .en_tanzil, language: .en)
            coredata.insert(surahTranslation: surahTranslation)
            if showLog {
                let ss = try coredata.getSurahTranslation(contentId: .en_tanzil, language: .en)
                print(ss)
            }
        } catch {
            print(error)
        }
    }

    func insertSurahTransliterationFromJsonToSQLite() {
        do {
            let surahTransliteration = try jsonRepo.getSurahTransliteration(contentId: .en_tanzil, language: .en)
            coredata.insert(surahTransliteration: surahTransliteration)
            if showLog {
                let ss = try coredata.getSurahTransliteration(contentId: .en_tanzil, language: .en)
                print(ss)
            }
        } catch {
            print(error)
        }
    }

    func insertAyatOfAllSurah() {
        do {
            let surahList = try coredata.getSurah()

            try surahList.forEach { surah in
                try insertAyatFromJsonToSQLite(surah: surah)
            }
        } catch {
            print(error)
        }
    }

    private func insertAyatFromJsonToSQLite(surah: SurahInfo) throws {
        let ayah = try jsonRepo.getAyat(of: surah, contentId: .indonesia_ar)
        let ayahTranslation = try jsonRepo.getAyahTranslation(of: surah, contentId: .en_hilali_quranenc, language: .en)
        let ayahTransliteration = try jsonRepo.getAyahTransliteration(of: surah, contentId: .transliteration_litequran, language: .en)

        coredata.insert(ayahTranslation: ayah)
        coredata.insert(ayahTranslation: ayahTranslation)
        coredata.insert(ayahTransliteration: ayahTransliteration)
        if showLog {
            let ayahCD = try coredata.getAyat(of: surah, contentId: .indonesia_ar)
            let ayahTranslationCD = try coredata.getAyahTranslation(of: surah, contentId: .en_hilali_quranenc, language: .en)
            let ayahTransliterationCD = try coredata.getAyahTransliteration(of: surah, contentId: .transliteration_litequran, language: .en)
            print(ayahCD)
            print(ayahTranslationCD)
            print(ayahTransliterationCD)
        }
    }
}
