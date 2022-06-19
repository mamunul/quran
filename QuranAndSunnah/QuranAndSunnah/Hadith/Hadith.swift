//
//  Hadith.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct TextContent<T: ContentID>: Decodable {
    var contentID: T
    var lang: Language
    var text: String
}

struct HadithText {
    var id: String
    var chapterNo: Int
    var sectionNo: String
    var section: String
    var hadithNo: String
    var isnad: String
    var matn: String
    var comment: String
    var grade: String

    var contentID: HadithContentID
    var lang: Language
    var contentType: ContentType
}

struct HadithChapter2: Decodable {
    var id: Int
    var title: String
    var chapterNo: Int
    var hadithNo: ClosedRange<Int>
    
    var contentID: HadithContentID
    var lang: Language
    var contentType: ContentType
}

struct Hadith: Identifiable { // this should be replaced with HadithText
    var id: String
    var chapterNo: Int
    var sectionNo: String
    var sectionTranslations: [TextContent<HadithContentID>]
    var section: String
    var hadithNo: String
    var hadithTranslations: [TextContent<HadithContentID>]
    var isnadTranslations: [TextContent<HadithContentID>]
    var matnTranslations: [TextContent<HadithContentID>]
    var hadith: String
    var isnad: String
    var matn: String
    var comment: String
    var gradeTranslations: [TextContent<HadithContentID>]
    var grade: String
    var bookmark: Bool
    var tags: [String]
}

struct HadithChapter: Identifiable {
    var id: Int
    var chapterNo: Int
    var title: String
    var titleTranslations: [TextContent<HadithContentID>]
//    var hadithList: [Hadith]
    var hadithNo: ClosedRange<Int>
}

protocol IHadithBook {
    var name: String { get set }
    var nameTranslations: [TextContent<HadithContentID>] { get set }
    var numberOfHadith: Int { get set }
    var type: HadithCollector { get set }
    var chapters: [HadithChapter] { get set }
}

struct HadithBook: IHadithBook {
    var name: String
    var nameTranslations: [TextContent<HadithContentID>]
    var numberOfHadith: Int
    var type: HadithCollector
    var chapters: [HadithChapter]
}

extension HadithBook {
    static let empty = HadithBook(name: "None", nameTranslations: [], numberOfHadith: 0, type: .none, chapters: [])
}

struct HadithCollector: Identifiable {
    static let none = HadithCollector(name: "", id: 0, contentID: .bukhari_1, pathComponent: "", chapterRange: 0 ..< 0)
    var name: String
    var id: Int

    var contentID: HadithContentID
    var pathComponent: String
    var chapterRange: Range<Int>
}
