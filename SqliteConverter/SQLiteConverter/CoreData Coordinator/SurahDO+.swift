//
//  SurahDO+.swift
//  SQLiteConverter
//
//  Created by newone on 14/6/22.
//

import Foundation

extension SurahDO {
    func convert() -> Surah2 {
        let surah =
            Surah2(
                id: id.hashValue,
                surahNo: Int(surahNo),
                ayahCount: Int(ayahCount),
                firstAyahNo: Int(firstAyahNo),
                lastAyahNo: Int(lastAyahNo),
                name: name ?? "",
                revelationOrder: Int(revelationOrder),
                revelaitonPlace: RevelationPlace(rawValue: revelaitonPlace ?? "") ?? .meccan
            )
        return surah
    }

    func load(surah: Surah2) {
        surahNo = Int16(surah.surahNo)
        ayahCount = Int16(surah.ayahCount)
        firstAyahNo = Int16(surah.firstAyahNo)
        lastAyahNo = Int16(surah.lastAyahNo)
        name = surah.name
        revelationOrder = Int16(surah.revelationOrder)
        revelaitonPlace = surah.revelaitonPlace.rawValue
    }
}

extension AyahDO {
}

extension SurahTranslationDO {
    func convert() -> TextContent<SurahNameID> {
        let content = TextContent(
            contentID: SurahNameID(rawValue: Int(contentId)) ?? .en_tanzil,
            lang: Language(rawValue: Int(language)) ?? .ar,
            text: text ?? ""
        )
        return content
    }

    func load(text: TextContent<SurahNameID>) {
        contentId = Int16(text.contentID.rawValue)
        language = Int16(text.lang.rawValue)
        self.text = text.text
    }
}
