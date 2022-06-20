//
//  NotebooksPresenter.swift
//  QuranAndSunnah
//
//  Created by newone on 20/6/22.
//

import Foundation

struct Note: Identifiable {
    var id: Int
    var markedText: String
    var chapterTitle: String
    var contentNo: String
    var note: String
    var bookName: String
}

struct Highlight: Identifiable {
    var id: Int
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

    func getHighlights() -> [QuranHighlight] {
        do {
            let hadithHighlights = try hadithNotebookRepository.getAllHighlights()
            let quranHighlights = try quranNotebookRepository.getAllHighlights()
            let tafsirHighlights = try tafsirNotebookRepository.getAllHighlights()

            var highlights = hadithHighlights.map { hadith in
                Highlight(
                    id: 0,
                    markedText: hadith.highlightedText,
                    chapterTitle: "\(hadith.chapterNo)",
                    contentNo: "\(hadith.hadithNo)",
                    bookName: "\(hadith.contentID.contentID.getFilePath())"
                )
            }
            
             highlights = quranHighlights.map { hadith in
                Highlight(
                    id: 0,
                    markedText: hadith.highlightedText,
                    chapterTitle: "\(hadith.ayatNo)",
                    contentNo: "\(hadith.surahNo)",
                    bookName: "\(hadith.contentID.contentID.getFilePath())"
                )
            }
            
             highlights = tafsirHighlights.map { hadith in
                Highlight(
                    id: 0,
                    markedText: hadith.highlightedText,
                    chapterTitle: "\(hadith.surahNo)",
                    contentNo: "\(hadith.tafsirAyah.ayahRange.lowerBound)",
                    bookName: "\(hadith.tafsirAyah.contentID.contentID.getFilePath())"
                )
            }

            self.highlights = highlights

        } catch {
        }
        return []
    }
}
