//
//  Hadith.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct HadithText: Identifiable {
    static let empty = HadithText(
        id: 0,
        chapterNo: 0,
        sectionNo: 0,
        section: "",
        hadithNo: 0,
        isnad: "",
        matn: "",
        comment: "",
        grade: "",
        contentID: ContentIdentity<HadithContentID>(
            contentID: .abudaud_1,
            lang: .en,
            contentType: .translation
        )
    )
    var id: Int
    var chapterNo: Int
    var sectionNo: Int
    var section: String
    var hadithNo: Int
    var isnad: String
    var matn: String
    var comment: String
    var grade: String

    var contentID: ContentIdentity<HadithContentID>
}

struct HadithChapter: Identifiable, Decodable {
    var id: Int
    var title: String
    var chapterNo: Int
    var hadithNo: ClosedRange<Int>

    var contentID: ContentIdentity<HadithContentID>
}

struct HadithCollector: Identifiable {
    static let none =
        HadithCollector(
            name: "",
            id: 0,
            pathComponent: "",
            chapterRange: 0 ..< 0,

            contentID: ContentIdentity<HadithContentID>(
                contentID: .bukhari_1,
                lang: .en,
                contentType: .translation
            )
        )
    var name: String
    var id: Int

    var pathComponent: String
    var chapterRange: Range<Int>

    var contentID: ContentIdentity<HadithContentID>
}
