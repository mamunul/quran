//
//  NotebookRepository.swift
//  QuranAndSunnah
//
//  Created by newone on 20/6/22.
//

import Foundation

protocol IHadithNotebookFacade {
    func getNotes(for hadithChapter: HadithChapter) -> [HadithNote]
    func getNotes(for hadithCollector: HadithCollector) -> [HadithNote]
    func getAllNotes() -> [HadithNote]
    func save(note: HadithNote)

    func getBookmarks(for hadithChapter: HadithChapter) -> [HadithBookmark]
    func getBookmarks(for hadithCollector: HadithCollector) -> [HadithBookmark]
    func getAllBookmarks() -> [HadithBookmark]
    func save(bookmark: HadithBookmark)

    func getHighlights(for hadithChapter: HadithChapter) -> [HadithHighlight]
    func getHighlights(for hadithCollector: HadithCollector) -> [HadithHighlight]
    func getAllHighlights() -> [HadithHighlight]
    func save(highlight: HadithHighlight)

    func getPin() -> HadithPin

    func save(pin: HadithPin)
}

class HadithNotebookRepository: IHadithNotebookFacade {
    func getNotes(for hadithChapter: HadithChapter) -> [HadithNote] {
        []
    }
    
    func getNotes(for hadithCollector: HadithCollector) -> [HadithNote] {
        []
    }
    
    func getAllNotes() -> [HadithNote] {
        []
    }
    
    func save(note: HadithNote) {
        
    }
    
    func getBookmarks(for hadithChapter: HadithChapter) -> [HadithBookmark] {
        []
    }
    
    func getBookmarks(for hadithCollector: HadithCollector) -> [HadithBookmark] {
        []
    }
    
    func getAllBookmarks() -> [HadithBookmark] {
        []
    }
    
    func save(bookmark: HadithBookmark) {
        
    }
    
    func getHighlights(for hadithChapter: HadithChapter) -> [HadithHighlight] {
        []
    }
    
    func getHighlights(for hadithCollector: HadithCollector) -> [HadithHighlight] {
        []
    }
    
    func getAllHighlights() -> [HadithHighlight] {
        []
    }
    
    func save(highlight: HadithHighlight) {
        
    }
    
    func getPin() -> HadithPin {
        HadithPin.empty
    }
    
    func save(pin: HadithPin) {
    }
    
}
