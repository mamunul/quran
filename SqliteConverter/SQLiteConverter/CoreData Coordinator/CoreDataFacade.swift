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
    func getSurahTranslation(content: SurahNameID, language: Language) -> [TextContent<SurahNameID>]
    func getSurahTransliteration(content: SurahNameID, language: Language) -> [TextContent<SurahNameID>]
    func getAyat(of surah: Surah) -> [Ayah2]
    func getAyahTranslation(of surah: Surah, content: AyahContentID, language: Language) -> [TextContent<AyahContentID>]
    func getAyahTransliterations(of surah: Surah, content: AyahContentID, language: Language) -> [TextContent<AyahContentID>]
}

class CoreDataFacade: IDataReadFacade {
    let coreDataStack = CoreDataStack.shared

    func getSurahTransliteration(content: SurahNameID, language: Language) -> [TextContent<SurahNameID>] {
        var translations = [TextContent<SurahNameID>]()
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

    func getAyahTranslation(of surah: Surah, content: AyahContentID, language: Language) -> [TextContent<AyahContentID>] {
        var translations = [TextContent<AyahContentID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(
            format: " ayahNo >= %@ AND ayahNo <= %@ AND language == %@",
            surah.firstAyahNo, surah.lastAyahNo, language.rawValue
        )
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } as? [TextContent<AyahContentID>] ?? [TextContent<AyahContentID>]()
        } catch {
            print(error)
        }
        return translations
    }

    func getAyahTransliterations(of surah: Surah, content: AyahContentID, language: Language) -> [TextContent<AyahContentID>] {
        var translations = [TextContent<AyahContentID>]()
        let surahFetch = SurahTranslationDO.fetchRequest()
        let context = coreDataStack.mainContext

        let predicate = NSComparisonPredicate(
            format: " ayahNo >= %@ AND ayahNo <= %@ AND language == %@",
            surah.firstAyahNo, surah.lastAyahNo, language.rawValue
        )
        surahFetch.predicate = predicate

        do {
            let surahObject = try context?.fetch(surahFetch)
            translations = surahObject?.map { $0.convert() } as? [TextContent<AyahContentID>] ?? [TextContent<AyahContentID>]()
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

    func getSurahTranslation(content: SurahNameID, language: Language) -> [TextContent<SurahNameID>] {
        var translations = [TextContent<SurahNameID>]()
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
