//
//  CoreDataFacade.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//

import CoreData
import Foundation

protocol IDataReadFacade {
    func getSurah() -> [Surah2]
    func getSurahTranslation(content: SurahNameID, language: Language) -> [SurahNameTranslation<SurahNameID>]
    func getSurahTransliteration(content: SurahNameID, language: Language) -> [SurahNameTranslation<SurahNameID>]
    func getAyat(of surah: Surah) -> [Ayah2]
    func getAyahTranslation(of surah: Surah, content: QuranTranslationID, language: Language) -> [AyahTraslation<QuranTranslationID>]
    func getAyahTransliterations(of surah: Surah, content: QuranTranslationID, language: Language) -> [AyahTraslation<QuranTranslationID>]
}

class CoreDataFacade: IDataReadFacade {
    let coreDataStack = CoreDataStack.shared

    static let shared = CoreDataFacade()

    private init() {}

    func getSurahTransliteration(content: SurahNameID, language: Language) -> [SurahNameTranslation<SurahNameID>] {
        var translations = [SurahNameTranslation<SurahNameID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(format: " contentId == %@ AND language  == %@", content.rawValue, language.rawValue)
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } ?? []
        } catch {
            print(error)
        }
        return translations
    }

    func getAyat(of surah: Surah) -> [Ayah2] {
        var translations = [Ayah2]()
        let surahFetch = AyahDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(format: " ayahNo >= %@ AND ayahNo <= %@", surah.firstAyahNo, surah.lastAyahNo)
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } ?? []
        } catch {
            print(error)
        }
        return translations
    }

    func getAyahTranslation(of surah: Surah, content: QuranTranslationID, language: Language) -> [AyahTraslation<QuranTranslationID>] {
        var translations = [AyahTraslation<QuranTranslationID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(
            format: " ayahNo >= %@ AND ayahNo <= %@ AND language == %@",
            surah.firstAyahNo, surah.lastAyahNo, language.rawValue
        )
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } as? [AyahTraslation<QuranTranslationID>] ?? [AyahTraslation<QuranTranslationID>]()
        } catch {
            print(error)
        }
        return translations
    }

    func getAyahTransliterations(of surah: Surah, content: QuranTranslationID, language: Language) -> [AyahTraslation<QuranTranslationID>] {
        var translations = [AyahTraslation<QuranTranslationID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(
            format: " ayahNo >= %@ AND ayahNo <= %@ AND language == %@",
            surah.firstAyahNo, surah.lastAyahNo, language.rawValue
        )
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } as? [AyahTraslation<QuranTranslationID>] ?? [AyahTraslation<QuranTranslationID>]()
        } catch {
            print(error)
        }
        return translations
    }

    func getSurah() -> [Surah2] {
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

    func getSurahTranslation(content: SurahNameID, language: Language) -> [SurahNameTranslation<SurahNameID>] {
        var translations = [SurahNameTranslation<SurahNameID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(format: " contentId == %@ AND language  == %@", content.rawValue, language.rawValue)
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
