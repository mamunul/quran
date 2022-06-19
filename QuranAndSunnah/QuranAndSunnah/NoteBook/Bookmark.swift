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
    var hadith: [HadithText]
}

struct QuranNote {
    var note: String
    var range: Range<Int>
    var highlightedText: String
    var ayatNo: Int
    
    var contentID: AyahContentID
    var lang: Language
    var contentType: ContentType
}

struct HadithNote {
    var note: String
    var range: Range<Int>
    var highlightedText: String
    var hadithNo: Int
    
    var contentID: HadithContentID
    var lang: Language
    var contentType: ContentType
}

struct TafsirNote {
    var note: String
    var range: Range<Int>
    var highlightedText: String

    var tafsirAyah: TafsirAyah2
}

struct QuranHighlight {
    var range: Range<Int>
    var highlightedText: String
    var ayatNo: Int
    
    var contentID: AyahContentID
    var lang: Language
    var contentType: ContentType
}

struct HadithHighlight {
    var range: Range<Int>
    var highlightedText: String
    var hadithCollector: HadithCollector
    var hadithNo: Int
    
    var contentID: HadithContentID
    var lang: Language
    var contentType: ContentType
}

struct TafsirHighlight {
    var range: Range<Int>
    var highlightedText: String
    var tafsirAyah: TafsirAyah2
}

struct QuranBookmark {
    var ayatNo: Int
    
    var contentID: AyahContentID
    var lang: Language
    var contentType: ContentType
}

struct HadithBookmark {
    var hadithNo: Int
    
    var contentID: HadithContentID
    var lang: Language
    var contentType: ContentType
}

struct QuranPin { // same for tafsir; doesnt require db - @appstorage is sufficient
    var ayah: Ayah
}

struct HadithPin { // doesnt require db - appstore is sufficient
    var hadithCollector: HadithCollector
    var hadith: HadithText
}
