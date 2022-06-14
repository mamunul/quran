//
//  Bookmark.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 31/5/22.
//

import Foundation
import SwiftUI

//struct Pin {
//    var quran: [Ayah]
//    var tafsir: [TafsirAyah]
//    var hadith: [Hadith]
//}

protocol Highlight {
    /// The highlighted range in the whole text.
    var range: Range<Int> { get set }
    var highlightedText: String { get set }
    var note: String { get set }
    /// The contentId will be used to differentiate various writers and language
    var writerId: Int { get set }
    /// The language of the highlighted text .
    var language: Language { get set }
}

/// A single highlight mark on a range of text of the Quran / Tafsir / Hadith.
// struct Highlight {
//    enum HighlightType {
//        case quran, hadith, tafsir
//    }
//
//    /// The highlighted range in the whole text.
//    var range: Range<Int>
//    /// The highlighted text
//    var text: String
//    /// The color used to mark the highlighted portion of the text.
//    var number: Int
//    /// The type of book - hadith/tafsir/quran where this highlight is applied.
//    var type: HighlightType
//    /// The language of the highlighted text .
//    var language: Language
//    /// The type of hadith / tafsir, as there are a multitude of collector of hadith and tafsir.
//    var subType: Int
// }

// struct Note {
//    /// The highlighted range in the whole text.
//    var range: Range<Int>
//    /// The highlighted text
//    var text: String
//    /// The number of the ayah in Quran or the number of the ayah in tafsir or the number of the hadith.
//    var number: Int
//    /// The type of book - hadith/tafsir/quran where this highlight is applied.
//    var type: Highlight.HighlightType
//    /// The language of the highlighted text .
//    var language: Language
//    /// The type of hadith / tafsir, as there are a multitude of collector of hadith and tafsir.
//    var subType: Int
//    /// The written notes of the highlighted text
//    var note: String
// }
