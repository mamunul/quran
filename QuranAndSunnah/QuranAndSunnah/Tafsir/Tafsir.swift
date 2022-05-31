//
//  Tafsir.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct TafsirAyah {
    var bookmark: Bool
    var textUrl: URL
    var translations: [URL]
    var ayahRange: Range<Int>
}

struct TafsirSurah {
    var surahNo: Int
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
