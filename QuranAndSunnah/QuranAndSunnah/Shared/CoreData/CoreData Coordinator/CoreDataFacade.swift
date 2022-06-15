//
//  CoreDataFacade.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//

import CoreData
import Foundation

protocol IDataReadFacade {
    func getSurah(contentID: SurahNameContentID) throws -> [Surah2]
    func getSurahTranslation(contentID: SurahTranslationID, language: Language) throws ->
        [SurahNameTranslation<SurahTranslationID>]
    func getSurahTransliteration(contentID: SurahTranslationID, language: Language) throws ->
        [SurahNameTranslation<SurahTranslationID>]
    func getAyat(of surah: Surah2, contentID: AyahContentID) throws -> [Ayah2]
    func getAyahTranslation(of surah: Surah2, contentID: AyahTranslationID, language: Language) throws -> [AyahTraslation<AyahTranslationID>]
    func getAyahTransliteration(of surah: Surah2, contentID: AyahTranslationID, language: Language) throws -> [AyahTraslation<AyahTranslationID>]
}

class CoreDataFacade: IDataReadFacade {
    let coreDataStack = CoreDataStack.shared

    static let shared = CoreDataFacade()

    private init() {}

    func getSurahTransliteration(contentID: SurahTranslationID, language: Language) throws
        -> [SurahNameTranslation<SurahTranslationID>] {
        var translations = [SurahNameTranslation<SurahTranslationID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate =
            NSPredicate(format: "contentId == \(contentID.rawValue) AND language  == \(language.rawValue) AND translation = false")
        surahFetch.predicate = predicate

        let surahObject = try context?.fetch(surahFetch)
        translations = surahObject?.map { $0.convert() } ?? []

        return translations
    }

    func getAyat(of surah: Surah2, contentID: AyahContentID) throws -> [Ayah2] {
        var translations = [Ayah2]()
        let surahFetch = AyahDO.fetchRequest()
        let context = coreDataStack.mainContext
        let predicate =
            NSPredicate(format: "ayahNo >= \(surah.firstAyahNo) AND ayahNo <= \(surah.lastAyahNo) AND contentId == \(contentID.rawValue)")
        surahFetch.predicate = predicate

        let surahObject = try context?.fetch(surahFetch)
        translations = surahObject?.map { $0.convert() } ?? []

        return translations
    }

    func getAyahTranslation(of surah: Surah2, contentID: AyahTranslationID, language: Language) throws -> [AyahTraslation<AyahTranslationID>] {
        var translations = [AyahTraslation<AyahTranslationID>]()
        let surahFetch = AyahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate =
            NSPredicate(format: "ayahNo >= \(surah.firstAyahNo) AND ayahNo <= \(surah.lastAyahNo) AND contentId == \(contentID.rawValue) AND language  == \(language.rawValue) AND translation = true")
        surahFetch.predicate = predicate

        let surahObject = try context?.fetch(surahFetch)
        translations = surahObject?.map { $0.convert() } as? [AyahTraslation<AyahTranslationID>] ?? [AyahTraslation<AyahTranslationID>]()

        return translations
    }

    func getAyahTransliteration(of surah: Surah2, contentID: AyahTranslationID, language: Language) throws -> [AyahTraslation<AyahTranslationID>] {
        var translations = [AyahTraslation<AyahTranslationID>]()
        let surahFetch = AyahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate =
            NSPredicate(format: "ayahNo >= \(surah.firstAyahNo) AND ayahNo <= \(surah.lastAyahNo) AND language == \(language.rawValue) AND translation = false")
        surahFetch.predicate = predicate

        let surahObject = try context?.fetch(surahFetch)
        translations = surahObject?.map { $0.convert() } as? [AyahTraslation<AyahTranslationID>] ?? [AyahTraslation<AyahTranslationID>]()

        return translations
    }

    func getSurah(contentID: SurahNameContentID) throws -> [Surah2] {
        var surah = [Surah2]()
        let surahFetch = SurahDO.fetchRequest()
        let predicate = NSPredicate(format: "contentId == \(contentID.rawValue)")
        surahFetch.predicate = predicate
        let context = coreDataStack.mainContext

        let surahObject = try context?.fetch(surahFetch)
        surah = surahObject?.map({ $0.convert() }) ?? []

        return surah
    }

    func getSurahTranslation(contentID: SurahTranslationID, language: Language) throws ->
        [SurahNameTranslation<SurahTranslationID>] {
        var translations = [SurahNameTranslation<SurahTranslationID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate =
            NSPredicate(format: "contentId == \(contentID.rawValue) AND language  == \(language.rawValue) AND translation = true")
        surahFetch.predicate = predicate

        let surahObject = try context?.fetch(surahFetch)
        translations = surahObject?.map { $0.convert() } ?? []

        return translations
    }
}
