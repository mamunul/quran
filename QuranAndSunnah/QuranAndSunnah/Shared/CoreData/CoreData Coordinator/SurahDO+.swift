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
                id: self.hashValue,
                surahNo: Int(surahNo),
                ayahCount: Int(ayahCount),
                firstAyahNo: Int(firstAyahNo),
                lastAyahNo: Int(lastAyahNo),
                name: name ?? "",
                revelationOrder: Int(revelationOrder),
                revelaitonPlace: RevelationPlace(rawValue: revelaitonPlace ?? "") ?? .meccan,
                contentID: SurahNameContentID(rawValue: Int(contentId)) ?? .en_unknown
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
    func convert() -> Ayah2 {
        let content = Ayah2(
            id: id.hashValue,
            ayahNo: Int(ayahNo),
            text: text!,
            bookmark: bookmark,
            language: .ar,
            contentID: AyahContentID(rawValue: Int(contentId)) ?? .indonesia_ar
        )
        return content
    }

    func load(ayah: Ayah2) {
        ayahNo = Int16(ayah.ayahNo)
        text = ayah.text
        bookmark = ayah.bookmark
        contentId = Int16(ayah.contentID.rawValue)
    }
}

extension AyahTranslationDO {
    func convert() -> AyahTraslation<QuranTranslationID> {
        let content = AyahTraslation(
            contentID: QuranTranslationID(rawValue: Int(contentId)) ?? .en_hilali_quranenc,
            lang: Language(rawValue: Int(language)) ?? .ar,
            text: text ?? "",
            ayahNo: Int(ayahNo)
        )
        return content
    }

    func load(text: AyahTraslation<QuranTranslationID>) {
        contentId = Int16(text.contentID.rawValue)
        language = Int16(text.lang.rawValue)
        self.text = text.text
        ayahNo = Int16(text.ayahNo)
    }
}

extension SurahTranslationDO {
    func convert() -> SurahNameTranslation<SurahNameID> {
        let content = SurahNameTranslation(
            contentID: SurahNameID(rawValue: Int(contentId)) ?? .en_tanzil,
            lang: Language(rawValue: Int(language)) ?? .ar,
            text: text ?? "",
            surahNo: Int(surahNo)
        )
        return content
    }

    func load(text: SurahNameTranslation<SurahNameID>) {
        contentId = Int16(text.contentID.rawValue)
        language = Int16(text.lang.rawValue)
        self.text = text.text
        surahNo = Int16(text.surahNo)
    }
}
