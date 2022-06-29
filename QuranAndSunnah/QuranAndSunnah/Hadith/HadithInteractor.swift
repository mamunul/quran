//
//  HadithInteractor.swift
//  QuranAndSunnah
//
//  Created by newone on 29/6/22.
//

import Foundation

class HadithInteractor {
    private var repo: IHadithDataReadFacade = HadithRepository()
    private var notebookRepo = HadithNotebookRepository()

    init(
        repo: IHadithDataReadFacade = HadithRepository(),
        notebookRepo: HadithNotebookRepository = HadithNotebookRepository()
    ) {
        self.repo = repo
        self.notebookRepo = notebookRepo
    }

    func search(in chapterList: [HadithChapter], collector: HadithCollector, searchString: String) throws -> [HadithChapter] {
        var filtered = [HadithChapter]()
        let searchStringLC = searchString.lowercased()
        try chapterList.forEach { hadithChapter in

            let hadithList = try getHadithEnglishList(of: hadithChapter, collector: collector)

            let first = hadithList.first { hadith in
                hadith.matn.lowercased().contains(searchStringLC)
            }

            if first != nil {
                filtered.append(hadithChapter)
            }
        }
        return filtered
    }

    func delete(bookmark: HadithBookmark) throws {
        try notebookRepo.remove(bookmark: bookmark)
    }

    func save(bookmark: HadithBookmark) throws {
        try notebookRepo.save(bookmark: bookmark)
    }

    func getBookmarks(of chapter: HadithChapter) throws -> [HadithBookmark] {
        let bookmarksList = try notebookRepo.getBookmarks(for: chapter)
        return bookmarksList
    }

    func isBookmarked(hadith: HadithText) throws -> Bool {
        let status = try notebookRepo.getBookmark(for: hadith) != .empty
        return status
    }

    func getHighlights(of chapter: HadithChapter) throws -> [HadithHighlight] {
        let hadithHighlights = try notebookRepo.getHighlights(for: chapter)
        return hadithHighlights
    }

    func getHighlights(of hadith: HadithText) throws -> [HadithHighlight] {
        let hadithHighlights = try notebookRepo.getHighlights(for: hadith)
        return hadithHighlights
    }

    func remove(highlight: HadithHighlight) throws {
        try notebookRepo.remove(highlight: highlight)
    }

    func save(highlights: [HadithHighlight], of hadith: HadithText) throws {
        try notebookRepo.save(highlights: highlights, of: hadith)
    }

    func getHadithCollectorList() -> [HadithCollector] {
        repo.getCollectorList()
    }

    func getChapterList(collector: HadithCollector) -> [HadithChapter] {
        repo.getChapterList(of: collector, language: .en)
    }

    func getHadithArabicList(of chapter: HadithChapter, collector: HadithCollector) throws -> [HadithText] {
        let list = try repo.getHadithList(of: chapter, collector: collector, language: .ar)
        return list
    }

    func getHadithEnglishList(of chapter: HadithChapter, collector: HadithCollector) throws -> [HadithText] {
        let list = try repo.getHadithList(of: chapter, collector: collector, language: .en)
        return list
    }
}
