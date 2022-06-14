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
    private let coreDataStack = CoreDataStack.shared

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

protocol IDataWriteFacade {
    func insert(surah: Surah2)
    func insert(ayah: Ayah2)
    func insert(surahTranslation: TextContent<SurahNameID>, for surah: Surah2)
    func insert(surahTransliteration: TextContent<SurahNameID>, for surah: Surah2)
    func insert(ayahTranslation: TextContent<AyahContentID>, for ayah: Ayah2)
    func insert(ayahTransliteration: TextContent<AyahContentID>, for ayah: Ayah2)
    func insert(surah: [Surah2])
    func insert(ayah: [Ayah2])
    func insert(surahTranslation: [TextContent<SurahNameID>], for surah: Surah2)
    func insert(surahTransliteration: [TextContent<SurahNameID>], for surah: Surah2)
    func insert(ayahTranslation: [TextContent<AyahContentID>], for ayah: Ayah2)
    func insert(ayahTransliteration: [TextContent<AyahContentID>], for ayah: Ayah2)
}

extension CoreDataFacade: IDataWriteFacade {
    func insert(surahTransliteration: TextContent<SurahNameID>, for surah: Surah2) {
    }

    func insert(surah: Surah2) {
        let surahDO = SurahDO(context: coreDataStack.mainContext!)
        surahDO.load(surah: surah)
        coreDataStack.saveContext()
    }

    func insert(surahTranslation: TextContent<SurahNameID>, for surah: Surah2) {
        let translation = SurahTranslationDO(context: coreDataStack.mainContext!)
        translation.load(text: surahTranslation, surahNo: surah.surahNo)
        coreDataStack.saveContext()
    }

    func insert(ayah: Ayah2) {
        let surahDO = AyahDO(context: coreDataStack.mainContext!)
        surahDO.load(ayah: ayah)
        coreDataStack.saveContext()
    }

    func insert(ayahTranslation: TextContent<AyahContentID>, for ayah: Ayah2) {
        let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
        surahDO.load(text: ayahTranslation, ayahNo: ayah.ayahNo)
        coreDataStack.saveContext()
    }

    func insert(ayahTransliteration: TextContent<AyahContentID>, for ayah: Ayah2) {
        let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
        surahDO.load(text: ayahTransliteration, ayahNo: ayah.ayahNo)
        coreDataStack.saveContext()
    }

    func insert(surah: [Surah2]) {
        surah.forEach {
            let surahDO = SurahDO(context: coreDataStack.mainContext!)
            surahDO.load(surah: $0)
        }

        coreDataStack.saveContext()
    }

    func insert(ayah: [Ayah2]) {
        ayah.forEach {
            let surahDO = AyahDO(context: coreDataStack.mainContext!)
            surahDO.load(ayah: $0)
        }

        coreDataStack.saveContext()
    }

    func insert(surahTranslation: [TextContent<SurahNameID>], for surah: Surah2) {
        surahTranslation.forEach {
            let surahDO = SurahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0, surahNo: surah.surahNo)
        }

        coreDataStack.saveContext()
    }

    func insert(surahTransliteration: [TextContent<SurahNameID>], for surah: Surah2) {
        surahTransliteration.forEach {
            let surahDO = SurahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0, surahNo: surah.surahNo)
        }
        coreDataStack.saveContext()
    }

    func insert(ayahTranslation: [TextContent<AyahContentID>], for ayah: Ayah2) {
        ayahTranslation.forEach {
            let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0, ayahNo: ayah.ayahNo)
        }

        coreDataStack.saveContext()
    }

    func insert(ayahTransliteration: [TextContent<AyahContentID>], for ayah: Ayah2) {
        ayahTransliteration.forEach {
            let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0, ayahNo: ayah.ayahNo)
        }
        coreDataStack.saveContext()
    }
}
