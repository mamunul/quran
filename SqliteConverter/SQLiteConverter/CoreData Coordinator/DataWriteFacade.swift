//
//  DataWriteFacade.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//

import CoreData
import Foundation

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
