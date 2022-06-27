//
//  Hadith.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct HadithText: Identifiable {
    static let empty = HadithText(
        id: UUID(),
        chapterNo: 0,
        sectionNo: 0,
        section: "",
        hadithNo: 0,
        isnad: "",
        matn: "",
        comment: "",
        grade: "",
        contentId: ContentIdentity<HadithContentID>(
            contentId: .abudaud_1,
            lang: .en,
            contentType: .translation
        )
    )
    var id = UUID()
    var chapterNo: Int
    var sectionNo: Int
    var section: String
    var hadithNo: Int
    var isnad: String
    var matn: String
    var comment: String
    var grade: String

    var contentId: ContentIdentity<HadithContentID>
}

struct HadithChapter: Identifiable, Codable {
    var id: Int
    var title: String
    var chapterNo: Int
    var hadithNo: ClosedRange<Int>

    var contentId: ContentIdentity<HadithContentID>
}

struct HadithCollector: Codable, Identifiable {
    static let none =
        HadithCollector(
            name: "",
            id: 0,
            pathComponent: "",
            chapterRange: 0 ..< 0,

            contentId: ContentIdentity<HadithContentID>(
                contentId: .bukhari_1,
                lang: .en,
                contentType: .translation
            )
        )
    var name: String
    var id: Int

    var pathComponent: String
    var chapterRange: Range<Int>

    var contentId: ContentIdentity<HadithContentID>
}
