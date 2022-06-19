//
//  Bookmark.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation
import SwiftUI

struct Tag {
    var tagText: String
    var ayat: [Ayah]
    var tafsirAyat: [TafsirAyah]
    var hadith: [Hadith]
}

struct QuranNote {
    var note: String
    var range: Range<Int>
    var highlightedText: String
    var contentID: AyahContentID
    var language: Language
    var ayat: Ayah
    var contentType: ContentType
}

struct HadithNote {
    var note: String
    var range: Range<Int>
    var highlightedText: String
    var contentID: HadithContentID
    var language: Language
    var hadith: Hadith
    var contentType: ContentType
}

struct TafsirNote {
    var note: String
    var range: Range<Int>
    var highlightedText: String
    var contentID: TafsirContentID
    var language: Language
    var tafsirAyat: TafsirAyah
    var contentType: ContentType
}

struct QuranHighlight {
    var range: Range<Int>
    var highlightedText: String
    var contentID: AyahContentID
    var language: Language
    var surahNo: Int
    var ayahNo: Int
//    var contentType: ContentType
}

struct HadithHighlight {
    var range: Range<Int>
    var highlightedText: String
    var contentID: HadithContentID
    var language: Language
    var hadithCollector: Int
    var chapterNo: Int
    var hadithNo: Int
//    var contentType: ContentType
}

struct TafsirHighlight {
    var range: Range<Int>
    var highlightedText: String
    var contentID: TafsirContentID
    var language: Language
    var surahNo: Int
    var ayahNo: Int
//    var contentType: ContentType
}

struct QuranBookmark {
    var contentID: AyahContentID
    var language: Language
    var surahNo: Int
    var ayahNo: Int
    var contentType: ContentType
}

struct HadithBookmark {
    var contentID: HadithContentID
    var language: Language
    var hadithCollector: Int
    var chapterNo: Int
    var hadithNo: Int
    var contentType: ContentType
}

struct QuranPin { // same for tafsir; doesnt require db - @appstorage is sufficient
    var ayahNo: Int
    var surahNo: Int
}

struct HadithPin { // doesnt require db - appstore is sufficient
    var hadithCollector: Int
    var chapterNo: Int
    var hadithNo: Int
}
