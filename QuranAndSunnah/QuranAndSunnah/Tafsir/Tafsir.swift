//
//  Tafsir.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct TafsirAyah: Codable, Identifiable {
    static let empty =
        TafsirAyah(
            id: 0,
            ayahRange: 0 ... 0,
            filePath: "",
            surahNo: 0,
            contentId:
            ContentIdentity<TafsirContentID>(
                contentId: .ibnKathir_shahih,
                lang: .en,
                contentType: .translation
            )
        )
    var id: Int
    var ayahRange: ClosedRange<Int>
    var filePath: String
    var surahNo: Int
    var contentId: ContentIdentity<TafsirContentID>
}

enum TafsirContentID: Int, ContentID {
    case ibnKathir_shahih
    func getFilePath() -> String {
        ""
    }
}
