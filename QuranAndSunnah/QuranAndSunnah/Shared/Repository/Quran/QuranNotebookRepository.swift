//
//  NotebookRepository.swift
//  QuranAndSunnah
//
//  Created by newone on 20/6/22.
//

import Foundation

protocol IQuranNotebookFacade {
    func getNotes(for surah: SurahInfo) -> [QuranNote]
    func getAllNotes() -> [QuranNote]
    func save(note: QuranNote)

    func getBookmarks(for surah: SurahInfo) -> [QuranBookmark]
    func getAllBookmarks() -> [QuranBookmark]
    func save(bookmark: QuranBookmark)

    func getHighlights(for surah: SurahInfo) -> [QuranHighlight]
    func getAllHighlights() -> [QuranHighlight]
    func save(highlight: QuranHighlight)

    func getPin() -> QuranPin

    func save(pin: QuranPin)
}

class QuranNotebookRepository: IQuranNotebookFacade {
    func getNotes(for surah: SurahInfo) -> [QuranNote] {
        []
    }

    func getAllNotes() -> [QuranNote] {
        []
    }

    func save(note: QuranNote) {
    }

    func getBookmarks(for surah: SurahInfo) -> [QuranBookmark] {
        []
    }

    func getAllBookmarks() -> [QuranBookmark] {
        []
    }

    func save(bookmark: QuranBookmark) {
    }

    func getHighlights(for surah: SurahInfo) -> [QuranHighlight] {
        []
    }

    func getAllHighlights() -> [QuranHighlight] {
        []
    }

    func save(highlight: QuranHighlight) {
    }

    func getPin() -> QuranPin {
        QuranPin.empty
    }

    func save(pin: QuranPin) {
    }
}
