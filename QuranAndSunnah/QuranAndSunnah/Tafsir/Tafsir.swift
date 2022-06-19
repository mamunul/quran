//
//  Tafsir.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct TafsirAyah2: Identifiable {
    var id: Int
    var ayahRange: ClosedRange<Int>
    var filePath: String

    var contentID: ContentIdentity<TafsirContentID>
}

enum TafsirContentID: ContentID {
    case ibnKathir_shahih
    func getFilePath() -> String {
        ""
    }
}
