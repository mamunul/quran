//
//  CoreDataFacade.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//

import CoreData
import Foundation

protocol IDataReadFacade {
    func getSurah(contentID: SurahNameContentID) -> [Surah2]
    func getSurahTranslation(contentID: SurahTranslationID, language: Language) ->
        [SurahNameTranslation<SurahTranslationID>]
    func getSurahTransliteration(contentID: SurahTranslationID, language: Language) ->
        [SurahNameTranslation<SurahTranslationID>]
    func getAyat(of surah: Surah2, contentID: AyahContentID) -> [Ayah2]
    func getAyahTranslation(of surah: Surah2, contentID: AyahTranslationID, language: Language) -> [AyahTraslation<AyahTranslationID>]
    func getAyahTransliterations(of surah: Surah2, contentID: AyahTranslationID, language: Language) -> [AyahTraslation<AyahTranslationID>]
}

class CoreDataFacade: IDataReadFacade {
    let coreDataStack = CoreDataStack.shared

    static let shared = CoreDataFacade()

    private init() {}

    func getSurahTransliteration(contentID: SurahTranslationID, language: Language)
        -> [SurahNameTranslation<SurahTranslationID>] {
        var translations = [SurahNameTranslation<SurahTranslationID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(format: " contentId == %@ AND language  == %@", contentID.rawValue, language.rawValue)
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } ?? []
        } catch {
            print(error)
        }
        return translations
    }

    func getAyat(of surah: Surah2, contentID: AyahContentID) -> [Ayah2] {
        var translations = [Ayah2]()
        let surahFetch = AyahDO.fetchRequest()
        let context = coreDataStack.mainContext
        let format = " ayahNo >= %@ AND ayahNo <= %@"
        let predicate = NSComparisonPredicate(format: format, surah.firstAyahNo, surah.lastAyahNo)
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } ?? []
        } catch {
            print(error)
        }
        return translations
    }

    func getAyahTranslation(of surah: Surah2, contentID: AyahTranslationID, language: Language) -> [AyahTraslation<AyahTranslationID>] {
        var translations = [AyahTraslation<AyahTranslationID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(
            format: " ayahNo >= %@ AND ayahNo <= %@ AND language == %@",
            surah.firstAyahNo, surah.lastAyahNo, language.rawValue
        )
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } as? [AyahTraslation<AyahTranslationID>] ?? [AyahTraslation<AyahTranslationID>]()
        } catch {
            print(error)
        }
        return translations
    }

    func getAyahTransliterations(of surah: Surah2, contentID: AyahTranslationID, language: Language) -> [AyahTraslation<AyahTranslationID>] {
        var translations = [AyahTraslation<AyahTranslationID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(
            format: " ayahNo >= %@ AND ayahNo <= %@ AND language == %@",
            surah.firstAyahNo, surah.lastAyahNo, language.rawValue
        )
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } as? [AyahTraslation<AyahTranslationID>] ?? [AyahTraslation<AyahTranslationID>]()
        } catch {
            print(error)
        }
        return translations
    }

    func getSurah(contentID: SurahNameContentID) -> [Surah2] {
        var surah = [Surah2]()
        let surahFetch = SurahDO.fetchRequest()
        let context = coreDataStack.mainContext
        do {
            let surahObject = try context?.fetch(surahFetch)
            surah = surahObject?.map({ $0.convert() }) ?? []
        } catch {
            print(error)
        }
        return surah
    }

    func getSurahTranslation(contentID: SurahTranslationID, language: Language) ->
        [SurahNameTranslation<SurahTranslationID>] {
        var translations = [SurahNameTranslation<SurahTranslationID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(format: " contentId == %@ AND language  == %@", contentID.rawValue, language.rawValue)
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } ?? []
        } catch {
            print(error)
        }
        return translations
    }
}
