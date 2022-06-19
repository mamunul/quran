//
//  Hadith.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct HadithText: Identifiable {
    var id: Int
    var chapterNo: Int
    var sectionNo: Int
    var section: String
    var hadithNo: Int
    var isnad: String
    var matn: String
    var comment: String
    var grade: String

    var contentID: HadithContentID
    var lang: Language
    var contentType: ContentType
}

struct HadithChapter2: Identifiable, Decodable {
    var id: Int
    var title: String
    var chapterNo: Int
    var hadithNo: ClosedRange<Int>

    var contentID: HadithContentID
    var lang: Language
    var contentType: ContentType
}

struct HadithCollector: Identifiable {
    static let none =
        HadithCollector(
            name: "",
            id: 0,
            pathComponent: "",
            chapterRange: 0 ..< 0,
            contentID: .bukhari_1,
            lang: .en,
            contentType: .translation
        )
    var name: String
    var id: Int

    var pathComponent: String
    var chapterRange: Range<Int>

    var contentID: HadithContentID
    var lang: Language
    var contentType: ContentType
}
