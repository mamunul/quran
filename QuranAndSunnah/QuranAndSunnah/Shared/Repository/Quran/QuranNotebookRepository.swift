//
//  NotebookRepository.swift
//  QuranAndSunnah
//
//  Created by newone on 20/6/22.
//

import Foundation

protocol IQuranNotebookFacade {
    func getNotes(for surah: SurahInfo) throws -> [QuranNote]
    func getAllNotes() throws -> [QuranNote]
    func save(note: QuranNote) throws

    func getBookmarks(for surah: SurahInfo) throws -> [QuranBookmark]
    func getAllBookmarks() throws -> [QuranBookmark]
    func save(bookmark: QuranBookmark) throws

    func getHighlights(for surah: SurahInfo) throws -> [QuranHighlight]
    func getAllHighlights() throws -> [QuranHighlight]
    func save(highlight: QuranHighlight) throws

    func getPin() -> QuranPin

    func save(pin: QuranPin)
}

class QuranNotebookRepository: IQuranNotebookFacade {
    private let notesPath = "Quran/notes.json"
    private let bookmarksPath = "Quran/bookmarks.json"
    private let highlightsPath = "Quran/highlights.json"

    private let userDefaultPinKey = "quran.pin"

    private let fileHandler = FileHandler()
    func getNotes(for surah: SurahInfo) throws -> [QuranNote] {
        let notes = try getAllNotes()
        let filteredNotes = notes.filter { highlight in
            surah.firstAyahNo <= highlight.ayatNo && surah.lastAyahNo >= highlight.ayatNo
        }
        return filteredNotes
    }

    func getAllNotes() throws -> [QuranNote] {
        let notes: [QuranNote] = try fileHandler.read(relativePath: notesPath)
        return notes
    }

    func save(note: QuranNote) throws {
        var notes = try getAllNotes()
        notes.append(note)
        try fileHandler.save(model: notes, relativePath: notesPath)
    }

    func getBookmarks(for surah: SurahInfo) throws -> [QuranBookmark] {
        let notes: [QuranBookmark] = try getAllBookmarks()
        let filteredNotes = notes.filter { highlight in
            surah.firstAyahNo <= highlight.ayatNo && surah.lastAyahNo >= highlight.ayatNo
        }
        return filteredNotes
    }

    func getAllBookmarks() throws -> [QuranBookmark] {
        let notes: [QuranBookmark] = try fileHandler.read(relativePath: bookmarksPath)
        return notes
    }

    func save(bookmark: QuranBookmark) throws {
        var notes = try getAllBookmarks()
        notes.append(bookmark)
        try fileHandler.save(model: notes, relativePath: bookmarksPath)
    }

    func getHighlights(for surah: SurahInfo) throws -> [QuranHighlight] {
        let notes: [QuranHighlight] = try getAllHighlights()

        let filteredNotes = notes.filter { highlight in
            surah.firstAyahNo <= highlight.ayatNo && surah.lastAyahNo >= highlight.ayatNo
        }
        return filteredNotes
    }

    func getAllHighlights() throws -> [QuranHighlight] {
        var notes = [QuranHighlight]()
        do {
            notes = try fileHandler.read(relativePath: highlightsPath)
        } catch {
            print(error)
        }
        return notes
    }

    func save(highlight: QuranHighlight) throws {
        var notes = try getAllHighlights()
        notes.append(highlight)
        try fileHandler.save(model: notes, relativePath: highlightsPath)
    }

    func getPin() -> QuranPin {
        let pin = UserDefaults.standard.object(forKey: userDefaultPinKey) as? QuranPin ?? .empty
        return pin
    }

    func save(pin: QuranPin) {
        UserDefaults.standard.set(pin, forKey: userDefaultPinKey)
    }
}
