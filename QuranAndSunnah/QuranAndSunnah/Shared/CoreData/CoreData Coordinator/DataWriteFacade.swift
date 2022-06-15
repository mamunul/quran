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
    func insert(surahTranslation: SurahNameTranslation<SurahTranslationID>, for surah: Surah2)
    func insert(surahTransliteration: SurahNameTranslation<SurahTranslationID>, for surah: Surah2)
    func insert(ayahTranslation: AyahTraslation<AyahTranslationID>, for ayah: Ayah2)
    func insert(ayahTransliteration: AyahTraslation<AyahTranslationID>, for ayah: Ayah2)
    func insert(surah: [Surah2])
    func insert(ayah: [Ayah2])
    func insert(surahTranslation: [SurahNameTranslation<SurahTranslationID>], for surah: Surah2)
    func insert(surahTransliteration: [SurahNameTranslation<SurahTranslationID>], for surah: Surah2)
    func insert(ayahTranslation: [AyahTraslation<AyahTranslationID>], for ayah: Ayah2)
    func insert(ayahTransliteration: [AyahTraslation<AyahTranslationID>], for ayah: Ayah2)
}

extension CoreDataFacade: IDataWriteFacade {
    func insert(surahTransliteration: SurahNameTranslation<SurahTranslationID>, for surah: Surah2) {
    }

    func insert(surah: Surah2) {
        let surahDO = SurahDO(context: coreDataStack.mainContext!)
        surahDO.load(surah: surah)
        coreDataStack.saveContext()
    }

    func insert(surahTranslation: SurahNameTranslation<SurahTranslationID>, for surah: Surah2) {
        let translation = SurahTranslationDO(context: coreDataStack.mainContext!)
        translation.load(text: surahTranslation)
        coreDataStack.saveContext()
    }

    func insert(ayah: Ayah2) {
        let surahDO = AyahDO(context: coreDataStack.mainContext!)
        surahDO.load(ayah: ayah)
        coreDataStack.saveContext()
    }

    func insert(ayahTranslation: AyahTraslation<AyahTranslationID>, for ayah: Ayah2) {
        let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
        surahDO.load(text: ayahTranslation)
        coreDataStack.saveContext()
    }

    func insert(ayahTransliteration: AyahTraslation<AyahTranslationID>, for ayah: Ayah2) {
        let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
        surahDO.load(text: ayahTransliteration)
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

    func insert(surahTranslation: [SurahNameTranslation<SurahTranslationID>], for surah: Surah2) {
        surahTranslation.forEach {
            let surahDO = SurahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0)
        }

        coreDataStack.saveContext()
    }

    func insert(surahTransliteration: [SurahNameTranslation<SurahTranslationID>], for surah: Surah2) {
        surahTransliteration.forEach {
            let surahDO = SurahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0)
        }
        coreDataStack.saveContext()
    }

    func insert(ayahTranslation: [AyahTraslation<AyahTranslationID>], for ayah: Ayah2) {
        ayahTranslation.forEach {
            let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0)
        }

        coreDataStack.saveContext()
    }

    func insert(ayahTransliteration: [AyahTraslation<AyahTranslationID>], for ayah: Ayah2) {
        ayahTransliteration.forEach {
            let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0)
        }
        coreDataStack.saveContext()
    }
}
