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
    func insert(surahTranslation: SurahNameTranslation<SurahTranslationID>)
    func insert(surahTransliteration: SurahNameTranslation<SurahTranslationID>)
    func insert(ayahTranslation: AyahTraslation<AyahTranslationID>)
    func insert(ayahTransliteration: AyahTraslation<AyahTranslationID>)
    func insert(surah: [Surah2])
    func insert(ayah: [Ayah2])
    func insert(surahTranslation: [SurahNameTranslation<SurahTranslationID>])
    func insert(surahTransliteration: [SurahNameTranslation<SurahTranslationID>])
    func insert(ayahTranslation: [AyahTraslation<AyahTranslationID>])
    func insert(ayahTransliteration: [AyahTraslation<AyahTranslationID>])
}

extension CoreDataFacade: IDataWriteFacade {
    func insert(surahTransliteration: SurahNameTranslation<SurahTranslationID>) {
        let translation = SurahTranslationDO(context: coreDataStack.mainContext!)
        translation.load(text: surahTransliteration, translation: false)
        coreDataStack.saveContext()
    }

    func insert(surah: Surah2) {
        let surahDO = SurahDO(context: coreDataStack.mainContext!)
        surahDO.load(surah: surah)
        coreDataStack.saveContext()
    }

    func insert(surahTranslation: SurahNameTranslation<SurahTranslationID>) {
        let translation = SurahTranslationDO(context: coreDataStack.mainContext!)
        translation.load(text: surahTranslation, translation: true)
        coreDataStack.saveContext()
    }

    func insert(ayah: Ayah2) {
        let surahDO = AyahDO(context: coreDataStack.mainContext!)
        surahDO.load(ayah: ayah)
        coreDataStack.saveContext()
    }

    func insert(ayahTranslation: AyahTraslation<AyahTranslationID>) {
        let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
        surahDO.load(text: ayahTranslation, translation: true)
        coreDataStack.saveContext()
    }

    func insert(ayahTransliteration: AyahTraslation<AyahTranslationID>) {
        let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
        surahDO.load(text: ayahTransliteration, translation: false)
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

    func insert(surahTranslation: [SurahNameTranslation<SurahTranslationID>]) {
        surahTranslation.forEach {
            let surahDO = SurahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0, translation: true)
        }

        coreDataStack.saveContext()
    }

    func insert(surahTransliteration: [SurahNameTranslation<SurahTranslationID>]) {
        surahTransliteration.forEach {
            let surahDO = SurahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0, translation: false)
        }
        coreDataStack.saveContext()
    }

    func insert(ayahTranslation: [AyahTraslation<AyahTranslationID>]) {
        ayahTranslation.forEach {
            let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0, translation: true)
        }

        coreDataStack.saveContext()
    }

    func insert(ayahTransliteration: [AyahTraslation<AyahTranslationID>]) {
        ayahTransliteration.forEach {
            let surahDO = AyahTranslationDO(context: coreDataStack.mainContext!)
            surahDO.load(text: $0, translation: false)
        }
        coreDataStack.saveContext()
    }
}
