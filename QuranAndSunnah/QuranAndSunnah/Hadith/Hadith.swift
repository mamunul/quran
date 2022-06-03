//
//  Hadith.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation

struct Hadith:Identifiable {
    var id: Int
    var chapterNo: Int
    var sectionNo: String
    var sectionTranslations: [Translation]
    var section: String
    var hadithNo: String
    var hadithTranslations: [Translation]
    var isnadTranslations: [Translation]
    var matnTranslations: [Translation]
    var hadith: String
    var isnad: String
    var matn: String
    var comment: String
    var gradeTranslations: [Translation]
    var grade: String
    var bookmark: Bool
    var tags: [String]
}

struct HadithChapter: Identifiable {
    var id: Int
    var chapterNo: Int
    var title: String
    var titleTranslations: [Translation]
    var hadithList: [Hadith]
}

struct HadithBook {
    var name: String
    var nameTranslations: [Translation]
    var numberOfHadith: Int
    var type: HadithCollector
    var chapters: [HadithChapter]
}

struct HadithCollector: Identifiable {
    var name: String
    var id: Int

    var pathComponent: String
    var chapterRange: Range<Int>
}
