//
//  DataWriteFacade.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//

import CoreData
import Foundation

protocol IDataWriteFacade {
    func insert(surah: SurahInfo)
    func insert(surahTranslation: SurahName)
    func insert(surahTransliteration: SurahName)
    func insert(ayahTranslation: Ayah)
    func insert(ayahTransliteration: Ayah)
    func insert(surah: [SurahInfo])
    func insert(surahTranslation: [SurahName])
    func insert(surahTransliteration: [SurahName])
    func insert(ayahTranslation: [Ayah])
    func insert(ayahTransliteration: [Ayah])
}

extension CoreDataFacade: IDataWriteFacade {
    func insert(surahTransliteration: SurahName) {
        let translation = SurahNameDO(context: coreDataStack.mainContext!)
        translation.load(text: surahTransliteration)
        coreDataStack.saveContext()
    }

    func insert(surah: SurahInfo) {
        let surahInfoDO = SurahInfoDO(context: coreDataStack.mainContext!)
        surahInfoDO.load(surah: surah)
        coreDataStack.saveContext()
    }

    func insert(surahTranslation: SurahName) {
        let translation = SurahNameDO(context: coreDataStack.mainContext!)
        translation.load(text: surahTranslation)
        coreDataStack.saveContext()
    }

    func insert(ayahTranslation: Ayah) {
        let surahInfoDO = AyahDO(context: coreDataStack.mainContext!)
        surahInfoDO.load(text: ayahTranslation)
        coreDataStack.saveContext()
    }

    func insert(ayahTransliteration: Ayah) {
        let surahInfoDO = AyahDO(context: coreDataStack.mainContext!)
        surahInfoDO.load(text: ayahTransliteration)
        coreDataStack.saveContext()
    }

    func insert(surah: [SurahInfo]) {
        surah.forEach {
            let surahInfoDO = SurahInfoDO(context: coreDataStack.mainContext!)
            surahInfoDO.load(surah: $0)
        }

        coreDataStack.saveContext()
    }

    func insert(surahTranslation: [SurahName]) {
        surahTranslation.forEach {
            let surahInfoDO = SurahNameDO(context: coreDataStack.mainContext!)
            surahInfoDO.load(text: $0)
        }

        coreDataStack.saveContext()
    }

    func insert(surahTransliteration: [SurahName]) {
        surahTransliteration.forEach {
            let surahInfoDO = SurahNameDO(context: coreDataStack.mainContext!)
            surahInfoDO.load(text: $0)
        }
        coreDataStack.saveContext()
    }

    func insert(ayahTranslation: [Ayah]) {
        ayahTranslation.forEach {
            let surahInfoDO = AyahDO(context: coreDataStack.mainContext!)
            surahInfoDO.load(text: $0)
        }

        coreDataStack.saveContext()
    }

    func insert(ayahTransliteration: [Ayah]) {
        ayahTransliteration.forEach {
            let surahInfoDO = AyahDO(context: coreDataStack.mainContext!)
            surahInfoDO.load(text: $0)
        }
        coreDataStack.saveContext()
    }
}
