//
//  NotebookRepository.swift
//  QuranAndSunnah
//
//  Created by newone on 20/6/22.
//

import Foundation

protocol ITafsirNotebookFacade {
    func getNotes(for surah: SurahInfo) -> [TafsirNote]
    func getNotes(for ayah: TafsirAyah) -> [TafsirNote]
    func getAllNotes() -> [TafsirNote]
    func save(note: TafsirNote)

    func getNotes(for surah: SurahInfo) -> [TafsirHighlight]
    func getNotes(for ayah: TafsirAyah) -> [TafsirHighlight]
    func getAllNotes() -> [TafsirHighlight]
    func save(note: TafsirHighlight)

    func getPin() -> TafsirPin

    func save(pin: TafsirPin)
}

class TafsirNotebookRepository: ITafsirNotebookFacade {
    func getNotes(for surah: SurahInfo) -> [TafsirNote] {
        []
    }

    func getNotes(for ayah: TafsirAyah) -> [TafsirNote] {
        []
    }

    func getAllNotes() -> [TafsirNote] {
        []
    }

    func save(note: TafsirNote) {
    }

    func getNotes(for surah: SurahInfo) -> [TafsirHighlight] {
        []
    }

    func getNotes(for ayah: TafsirAyah) -> [TafsirHighlight] {
        []
    }

    func getAllNotes() -> [TafsirHighlight] {
        []
    }

    func save(note: TafsirHighlight) {
    }

    func getPin() -> TafsirPin {
        .empty
    }

    func save(pin: TafsirPin) {
    }
}
