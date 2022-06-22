//
//  NotebookRepository.swift
//  QuranAndSunnah
//
//  Created by newone on 20/6/22.
//

import Foundation

protocol ITafsirNotebookFacade {
    func getNotes(for surah: SurahInfo) throws -> [TafsirNote]
    func getNotes(for ayah: TafsirAyah) throws -> [TafsirNote]
    func getAllNotes() throws -> [TafsirNote]
    func save(note: TafsirNote) throws

    func getHighlights(for surah: SurahInfo) throws -> [TafsirHighlight]
    func getHighlights(for ayah: TafsirAyah) throws -> [TafsirHighlight]
    func getAllHighlights() throws -> [TafsirHighlight]
    func save(highlight: TafsirHighlight) throws

    func getPin() -> TafsirPin

    func save(pin: TafsirPin)
}

class TafsirNotebookRepository: ITafsirNotebookFacade {
    private let notesPath = "Tafsir/notes.json"
    private let bookmarksPath = "Tafsir/bookmarks.json"
    private let highlightsPath = "Tafsir/highlights.json"

    private let userDefaultPinKey = "tafsir.pin"
    private let fileHandler = FileHandler()

    func getNotes(for surah: SurahInfo) throws -> [TafsirNote] {
        let notes = try getAllNotes()
        let filteredNotes = notes.filter { highlight in
            surah.firstAyahNo <= highlight.tafsirAyah.ayahRange.lowerBound &&
                highlight.tafsirAyah.ayahRange.upperBound >= surah.firstAyahNo
        }
        return filteredNotes
    }

    func getNotes(for ayah: TafsirAyah) throws -> [TafsirNote] {
        let notes = try getAllNotes()
        let filteredNotes = notes.filter { highlight in
            ayah.ayahRange == highlight.tafsirAyah.ayahRange
        }
        return filteredNotes
    }

    func getAllNotes() throws -> [TafsirNote] {
        let notes: [TafsirNote] = try fileHandler.read(relativePath: highlightsPath)
        return notes
    }

    func save(note: TafsirNote) throws {
        var notes = try getAllNotes()
        notes.append(note)
        try fileHandler.save(model: notes, relativePath: notesPath)
    }

    func getHighlights(for surah: SurahInfo) throws -> [TafsirHighlight] {
        let notes: [TafsirHighlight] = try getAllHighlights()

        let filteredNotes = notes.filter { highlight in
            surah.firstAyahNo <= highlight.tafsirAyah.ayahRange.lowerBound &&
                highlight.tafsirAyah.ayahRange.upperBound >= surah.firstAyahNo
        }
        return filteredNotes
    }

    func getHighlights(for ayah: TafsirAyah) throws -> [TafsirHighlight] {
        let notes: [TafsirHighlight] = try getAllHighlights()

        let filteredNotes = notes.filter { highlight in
            ayah.surahNo == highlight.surahNo &&
            ayah.ayahRange == highlight.tafsirAyah.ayahRange
        }
        return filteredNotes
    }

    func getAllHighlights() throws -> [TafsirHighlight] {
        var notes = [TafsirHighlight]()
        do {
            notes = try fileHandler.read(relativePath: highlightsPath)
        } catch {
            print(error)
        }
        return notes
    }

    func save(highlights: [TafsirHighlight], for ayah: TafsirAyah) throws {
        var notes = try getAllHighlights()
        
        notes.removeAll { highlight in
            highlight.surahNo == ayah.surahNo &&
            highlight.tafsirAyah.ayahRange == ayah.ayahRange
        }
        
        notes.append(contentsOf:highlights)
        try fileHandler.save(model: notes, relativePath: highlightsPath)
    }

    func save(highlight: TafsirHighlight) throws {
        var notes = try getAllHighlights()
        notes.append(highlight)
        try fileHandler.save(model: notes, relativePath: highlightsPath)
    }

    func getPin() -> TafsirPin {
        let pin = UserDefaults.standard.object(forKey: userDefaultPinKey) as? TafsirPin ?? .empty
        return pin
    }

    func save(pin: TafsirPin) {
        UserDefaults.standard.set(pin, forKey: userDefaultPinKey)
    }
}
