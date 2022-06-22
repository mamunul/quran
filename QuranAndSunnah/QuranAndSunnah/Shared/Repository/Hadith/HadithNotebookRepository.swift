//
//  NotebookRepository.swift
//  QuranAndSunnah
//
//  Created by newone on 20/6/22.
//

import Foundation

protocol IHadithNotebookFacade {
    func getNotes(for hadithChapter: HadithChapter) throws -> [HadithNote]
    func getNotes(for hadithCollector: HadithCollector) throws -> [HadithNote]
    func getAllNotes() throws -> [HadithNote]
    func save(note: HadithNote) throws

    func getBookmarks(for hadithChapter: HadithChapter) throws -> [HadithBookmark]
    func getBookmarks(for hadithCollector: HadithCollector) throws -> [HadithBookmark]
    func getAllBookmarks() throws -> [HadithBookmark]
    func save(bookmark: HadithBookmark) throws

    func getHighlights(for hadithChapter: HadithChapter) throws -> [HadithHighlight]
    func getHighlights(for hadithCollector: HadithCollector) throws -> [HadithHighlight]
    func getAllHighlights() throws -> [HadithHighlight]
    func save(highlight: HadithHighlight) throws

    func getPin() -> HadithPin

    func save(pin: HadithPin)
}

class HadithNotebookRepository: IHadithNotebookFacade {
    private let notesPath = "Hadith/notes.json"
    private let bookmarksPath = "Hadith/bookmarks.json"
    private let highlightsPath = "Hadith/highlights.json"

    private let userDefaultPinKey = "hadith.pin"
    private let fileHandler = FileHandler()
    func getNotes(for hadithChapter: HadithChapter) throws -> [HadithNote] {
        let notes = try getAllNotes()
        let filteredNotes = notes.filter { highlight in
            hadithChapter.chapterNo == highlight.chapterNo
        }
        return filteredNotes
    }

    func getNotes(for hadithCollector: HadithCollector) throws -> [HadithNote] {
        let notes = try getAllNotes()
        let filteredNotes = notes.filter { highlight in
            hadithCollector.contentId.contentId == highlight.contentId.contentId
        }
        return filteredNotes
    }

    func getAllNotes() throws -> [HadithNote] {
        let notes: [HadithNote] = try fileHandler.read(relativePath: highlightsPath)
        return notes
    }

    func save(note: HadithNote) throws {
        var notes = try getAllNotes()
        notes.append(note)
        try fileHandler.save(model: notes, relativePath: notesPath)
    }

    func getBookmark(for hadith: HadithText) throws -> HadithBookmark {
        let notes: [HadithBookmark] = try getAllBookmarks()
        let filteredNotes = notes.filter { highlight in
            hadith.chapterNo == highlight.chapterNo && hadith.hadithNo == highlight.hadithNo
        }
        return filteredNotes.first ?? HadithBookmark.empty
    }

    func getBookmarks(for hadithChapter: HadithChapter) throws -> [HadithBookmark] {
        let notes: [HadithBookmark] = try getAllBookmarks()
        let filteredNotes = notes.filter { highlight in
            hadithChapter.chapterNo == highlight.chapterNo
        }
        return filteredNotes
    }

    func getBookmarks(for hadithCollector: HadithCollector) throws -> [HadithBookmark] {
        let notes: [HadithBookmark] = try getAllBookmarks()
        let filteredNotes = notes.filter { highlight in
            hadithCollector.contentId.contentId == highlight.contentId.contentId
        }
        return filteredNotes
    }

    func getAllBookmarks() throws -> [HadithBookmark] {
        var notes = [HadithBookmark]()
        do {
            notes = try fileHandler.read(relativePath: bookmarksPath)
        } catch {
            print(error)
        }
        return notes
    }

    func remove(bookmark: HadithBookmark) throws {
        var notes = try getAllBookmarks()
        notes.removeAll { element in
            element.hadithNo == bookmark.hadithNo &&
                element.chapterNo == bookmark.chapterNo &&
                element.contentId.contentId == bookmark.contentId.contentId
        }
        try fileHandler.save(model: notes, relativePath: bookmarksPath)
    }

    func save(bookmark: HadithBookmark) throws {
        var notes = try getAllBookmarks()
        notes.append(bookmark)
        try fileHandler.save(model: notes, relativePath: bookmarksPath)
    }

    func getHighlights(for hadith: HadithText) throws -> [HadithHighlight] {
        let notes: [HadithHighlight] = try getAllHighlights()

        let filteredNotes = notes.filter { highlight in
            hadith.hadithNo == highlight.hadithNo && hadith.chapterNo == highlight.chapterNo
        }
        return filteredNotes
    }

    func getHighlights(for hadithChapter: HadithChapter) throws -> [HadithHighlight] {
        let notes: [HadithHighlight] = try getAllHighlights()

        let filteredNotes = notes.filter { highlight in
            hadithChapter.chapterNo == highlight.chapterNo
        }
        return filteredNotes
    }

    func getHighlights(for hadithCollector: HadithCollector) throws -> [HadithHighlight] {
        let notes: [HadithHighlight] = try getAllHighlights()

        let filteredNotes = notes.filter { highlight in
            hadithCollector.contentId.contentId == highlight.contentId.contentId
        }
        return filteredNotes
    }

    func getAllHighlights() throws -> [HadithHighlight] {
        var notes = [HadithHighlight]()
        do {
            notes = try fileHandler.read(relativePath: highlightsPath)
        } catch {
            print(error)
        }
        return notes
    }

    func remove(highlight: HadithHighlight) throws {
        var notes = try getAllHighlights()
        notes.removeAll { element in
            element.hadithNo == highlight.hadithNo &&
                element.chapterNo == highlight.chapterNo &&
                element.contentId.contentId == highlight.contentId.contentId &&
                element.range == highlight.range
        }
        try fileHandler.save(model: notes, relativePath: highlightsPath)
    }

    func save(highlight: HadithHighlight) throws {
        var notes = try getAllHighlights()
        notes.append(highlight)
        try fileHandler.save(model: notes, relativePath: highlightsPath)
    }

    func getPin() -> HadithPin {
        let pin = UserDefaults.standard.object(forKey: userDefaultPinKey) as? HadithPin ?? .empty
        return pin
    }

    func save(pin: HadithPin) {
        UserDefaults.standard.set(pin, forKey: userDefaultPinKey)
    }
}
