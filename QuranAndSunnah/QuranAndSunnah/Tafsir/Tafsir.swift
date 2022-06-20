//
//  Tafsir.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct TafsirAyah: Identifiable {
    static let empty =
        TafsirAyah(
            id: 0,
            ayahRange: 0 ... 0,
            filePath: "",
            contentID:
            ContentIdentity<TafsirContentID>(
                contentID: .ibnKathir_shahih,
                lang: .en,
                contentType: .translation
            )
        )
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
