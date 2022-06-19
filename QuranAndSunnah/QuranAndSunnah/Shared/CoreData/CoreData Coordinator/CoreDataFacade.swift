//
//  CoreDataFacade.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//

import CoreData
import Foundation

protocol IDataReadFacade {
    func getSurah() throws -> [SurahInfo]
    func getSurahTranslation(contentID: SurahNameContentID, language: Language) throws ->
        [SurahName]
    func getSurahTransliteration(contentID: SurahNameContentID, language: Language) throws ->
        [SurahName]
    func getAyat(of surah: SurahInfo, contentID: AyahContentID) throws -> [Ayah]
    func getAyahTranslation(of surah: SurahInfo, contentID: AyahContentID, language: Language) throws -> [Ayah]
    func getAyahTransliteration(of surah: SurahInfo, contentID: AyahContentID, language: Language) throws -> [Ayah]
}

class CoreDataFacade: IDataReadFacade {
    let coreDataStack = CoreDataStack.shared

    static let shared = CoreDataFacade()

    private init() {}

    func getSurahTransliteration(contentID: SurahNameContentID, language: Language) throws
        -> [SurahName] {
        var translations = [SurahName]()
        let surahFetch = SurahNameDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate =
            NSPredicate(format: "contentId == \(contentID.rawValue) AND language  == \(language.rawValue) AND translation = false")
        surahFetch.predicate = predicate

        let surahObject = try context?.fetch(surahFetch)
        translations = surahObject?.map { $0.convert() } ?? []

        return translations
    }

    func getAyat(of surah: SurahInfo, contentID: AyahContentID) throws -> [Ayah] {
        var translations = [Ayah]()
        let surahFetch = AyahDO.fetchRequest()
        let context = coreDataStack.mainContext
        let predicate =
            NSPredicate(format: "ayahNo >= \(surah.firstAyahNo) AND ayahNo <= \(surah.lastAyahNo) AND contentId == \(contentID.rawValue)")
        surahFetch.predicate = predicate

        let surahObject = try context?.fetch(surahFetch)
        translations = surahObject?.map { $0.convert() } ?? []

        return translations
    }

    func getAyahTranslation(of surah: SurahInfo, contentID: AyahContentID, language: Language) throws -> [Ayah] {
        var translations = [Ayah]()
        let surahFetch = AyahDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate =
            NSPredicate(format: "ayahNo >= \(surah.firstAyahNo) AND ayahNo <= \(surah.lastAyahNo) AND contentId == \(contentID.rawValue) AND language  == \(language.rawValue) AND translation = true")
        surahFetch.predicate = predicate

        let surahObject = try context?.fetch(surahFetch)
        translations = surahObject?.map { $0.convert() } as? [Ayah] ?? [Ayah]()

        return translations
    }

    func getAyahTransliteration(of surah: SurahInfo, contentID: AyahContentID, language: Language) throws -> [Ayah] {
        var translations = [Ayah]()
        let surahFetch = AyahDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate =
            NSPredicate(format: "ayahNo >= \(surah.firstAyahNo) AND ayahNo <= \(surah.lastAyahNo) AND language == \(language.rawValue) AND translation = false")
        surahFetch.predicate = predicate

        let surahObject = try context?.fetch(surahFetch)
        translations = surahObject?.map { $0.convert() } as? [Ayah] ?? [Ayah]()

        return translations
    }

    func getSurah() throws -> [SurahInfo] {
        var surah = [SurahInfo]()
        let surahFetch = SurahInfoDO.fetchRequest()
        let context = coreDataStack.mainContext

        let surahObject = try context?.fetch(surahFetch)
        surah = surahObject?.map({ $0.convert() }) ?? []

        return surah
    }

    func getSurahTranslation(contentID: SurahNameContentID, language: Language) throws ->
        [SurahName] {
        var translations = [SurahName]()
        let surahFetch = SurahNameDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate =
            NSPredicate(format: "contentId == \(contentID.rawValue) AND language  == \(language.rawValue) AND translation = true")
        surahFetch.predicate = predicate

        let surahObject = try context?.fetch(surahFetch)
        translations = surahObject?.map { $0.convert() } ?? []

        return translations
    }
}
