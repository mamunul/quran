//
//  SurahInfoDO+.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//

import Foundation

extension SurahInfoDO {
    func convert() -> SurahInfo {
        let surah =
            SurahInfo(
                id: hashValue,
                surahNo: Int(surahNo),
                ayahCount: Int(ayahCount),
                firstAyahNo: Int(firstAyahNo),
                lastAyahNo: Int(lastAyahNo),
                revelationOrder: Int(revelationOrder),
                revelaitonPlace: RevelationPlace(rawValue: revelaitonPlace ?? "") ?? .meccan
            )
        return surah
    }

    func load(surah: SurahInfo) {
        surahNo = Int16(surah.surahNo)
        ayahCount = Int16(surah.ayahCount)
        firstAyahNo = Int16(surah.firstAyahNo)
        lastAyahNo = Int16(surah.lastAyahNo)
        revelationOrder = Int16(surah.revelationOrder)
        revelaitonPlace = surah.revelaitonPlace.rawValue
    }
}

extension AyahDO {
    func convert() -> Ayah {
        let content = Ayah(
            id: Int(ayahNo),
            text: text ?? "",
            ayahNo: Int(ayahNo),
            surahNo: Int(surahNo),
            contentID: AyahContentID(rawValue: Int(contentId)) ?? .en_hilali_quranenc,
            lang: Language(rawValue: Int(language)) ?? .ar,
            contentType: ContentType(rawValue: Int(0)) ?? .original
        )
        return content
    }

    func load(text: Ayah) {
        contentId = Int16(text.contentID.rawValue)
        language = Int16(text.lang.rawValue)
        self.text = text.text
        ayahNo = Int16(text.ayahNo)
        contentType = Int16(text.contentType.rawValue)
        surahNo = Int16(surahNo)
    }
}

extension SurahNameDO {
    func convert() -> SurahName {
        let content = SurahName(
            text: text ?? "",
            surahNo: Int(surahNo),
            contentID: SurahNameContentID(rawValue: Int(contentId)) ?? .en_tanzil,
            lang: Language(rawValue: Int(language)) ?? .ar,
            contentType: ContentType(rawValue: Int(0)) ?? .original
        )
        return content
    }

    func load(text: SurahName) {
        contentId = Int16(text.contentID.rawValue)
        language = Int16(text.lang.rawValue)
        self.text = text.text
        surahNo = Int16(text.surahNo)
        contentType = Int16(text.contentType.rawValue)
    }
}
