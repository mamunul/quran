//
//  CoreDataFacade.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//

import CoreData
import Foundation

protocol IDataFacade {
    func getSurah() -> [Surah2]
    func getSurahTranslation(content: SurahNameID, language: Language) -> [TextContent<SurahNameID>]
//    func getSurahTransliteration(content: SurahNameID, language: Language) -> [TextContent<SurahNameID>]
//    func getAyat(of surah: Surah) -> [Ayah2]
//    func getAyahTranslation(of surah: Surah, content: AyahContentID, language: Language) -> [TextContent<AyahContentID>]
//    func getAyahTransliterations(of surah: Surah, content: AyahContentID, language: Language) -> [TextContent<AyahContentID>]

    func insert(surah: Surah2)
//    func insert(ayah: Ayah2)
    func insert(surahTranslation: TextContent<SurahNameID>, for surah: Surah2)
//    func insert(surahTransliteration: TextContent<SurahNameID>, for surah: Surah2)
//    func insert(ayahTranslation: TextContent<AyahContentID>, for ayah: Ayah2)
//    func insert(ayahTransliteration: TextContent<AyahContentID>, for ayah: Ayah2)
//    func insert(surah: [Surah2])
//    func insert(ayah: [Ayah2])
//    func insert(surahTranslation: [TextContent<SurahNameID>], for surah: Surah2)
//    func insert(surahTransliteration: [TextContent<SurahNameID>], for surah: Surah2)
//    func insert(ayahTranslation: [TextContent<AyahContentID>], for ayah: Ayah2)
//    func insert(ayahTransliteration: [TextContent<AyahContentID>], for ayah: Ayah2)
}

class CoreDataFacade: IDataFacade {
    let persistenceController = PersistenceController.shared

    func getSurah() -> [Surah2] {
        var surah = [Surah2]()
        let surahFetch = SurahDO.fetchRequest()
        let context = persistenceController.container?.viewContext
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
        let context = persistenceController.container?.viewContext

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

    func insert(surah: Surah2) {
        let surahDO = SurahDO(context: persistenceController.container!.viewContext)
        surahDO.load(surah: surah)
        persistenceController.saveContext()
    }

    func insert(surahTranslation: TextContent<SurahNameID>, for surah: Surah2) {
        let translation = SurahTranslationDO(context: persistenceController.container!.viewContext)
        translation.load(text: surahTranslation)
        persistenceController.saveContext()
    }
}
