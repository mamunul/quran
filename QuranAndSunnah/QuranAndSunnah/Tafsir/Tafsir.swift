//
//  Tafsir.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct TafsirAyah: Identifiable {
    var id: Int
    var bookmark: Bool
    var text: String
    var path: String
}

enum TafsirContentID:ContentID{
    case ibnKathir_shahih
}

struct TafsirSurah: Identifiable {
    var id: Int
    var surahNo: Int
    var ayahCount: Int
    var firstAyahNo: Int
    var lastAyahNo: Int
    var name: String
    var nameTranslations: [TextContent<SurahNameID>]
    var nameTransliterations: [TextContent<SurahNameID>]
    var revelationOrder: Int
    var revelaitonPlace: Surah.RevelationPlace
    var ayat: [TafsirAyah]
}

struct Tafsir {
    enum TafsirWriter {
        case ibnKathir
    }

    var name: String
    var type: TafsirWriter
    var surah: [TafsirSurah]
}
