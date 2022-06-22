//
//  NotebooksPresenter.swift
//  QuranAndSunnah
//
//  Created by newone on 20/6/22.
//

import Foundation

struct Tag: Codable {
    var text: String
    var id: Int
}

struct Note: Identifiable {
    var id: Int
    var range: ClosedRange<Int>
    var markedText: String
    var chapterTitle: String
    var contentNo: String
    var note: String
    var bookName: String
}

struct Highlight: Identifiable {
    var id = UUID()
    var range: ClosedRange<Int>
    var markedText: String
    var chapterTitle: String
    var contentNo: String
    var bookName: String
}

struct Bookmark: Identifiable {
    var id: Int
    var chapterTitle: String
    var contentNo: String
    var bookName: String
}

class NotebooksPresenter: ObservableObject {
    @Published var highlights = [Highlight]()
    private let hadithNotebookRepository = HadithNotebookRepository()
    private let quranNotebookRepository = QuranNotebookRepository()
    private let tafsirNotebookRepository = TafsirNotebookRepository()

    func getHighlights() {
        
        highlights.removeAll()
        do {
            let hadithHighlights = try hadithNotebookRepository.getAllHighlights()
            let quranHighlights = try quranNotebookRepository.getAllHighlights()
            let tafsirHighlights = try tafsirNotebookRepository.getAllHighlights()

            var highlight = hadithHighlights.map { hadith in
                Highlight(
                    id: UUID(),
                    range: hadith.markedRange,
                    markedText: hadith.highlightedText,
                    chapterTitle: "Chapter:\(hadith.chapterNo)",
                    contentNo: "HadithNo:\(hadith.hadithNo)",
                    bookName: "Hadith:\(hadith.contentId.contentId.getFilePath())"
                )
            }
            highlights.append(contentsOf: highlight)
            highlight = quranHighlights.map { hadith in
                Highlight(
                    id: UUID(),
                    range: hadith.markedRange,
                    markedText: hadith.highlightedText,
                    chapterTitle: "AyatNo:\(hadith.ayatNo)",
                    contentNo: "Surah:\(hadith.surahNo)",
                    bookName: "Quran:\(hadith.contentId.contentId.getFilePath())"
                )
            }
            highlights.append(contentsOf: highlight)
            highlight = tafsirHighlights.map { hadith in
                Highlight(
                    id: UUID(),
                    range: hadith.markedRange,
                    markedText: hadith.highlightedText,
                    chapterTitle: "\(hadith.surahNo)",
                    contentNo: "AyatNo:\(hadith.tafsirAyah.ayahRange.lowerBound)",
                    bookName: "IbnKathir:\(hadith.tafsirAyah.contentId.contentId.getFilePath())"
                )
            }

            highlights.append(contentsOf: highlight)

        } catch {
            print(error)
        }
    }
}
