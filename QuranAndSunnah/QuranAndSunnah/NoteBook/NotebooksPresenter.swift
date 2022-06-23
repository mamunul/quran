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

enum DocumentType: String {
    case quran, hadith, tafsir
}

struct Highlight: Identifiable {
    var id = UUID()
    var range: ClosedRange<Int>
    var markedText: String
    var chapterTitle: String
    var contentNo: String
    var bookName: String
    var type: DocumentType
}

struct Bookmark: Identifiable {
    var id = UUID()
    var chapterTitle: String
    var contentNo: String
    var bookName: String
    var type: DocumentType
}

class NotebooksPresenter: ObservableObject {
    @Published var quranHighlights = [QuranHighlight]()
    @Published var tafsirHighlights = [TafsirHighlight]()
    @Published var hadithHighlights = [HadithHighlight]()
    @Published var quranBookmarks = [QuranBookmark]()
    @Published var hadithBookmarks = [HadithBookmark]()
    private let hadithNotebookRepository = HadithNotebookRepository()
    private let quranNotebookRepository = QuranNotebookRepository()
    private let tafsirNotebookRepository = TafsirNotebookRepository()
    private let hadithRepo = HadithRepository()
    private let quranRepo = QuranJsonFacade()
    @Published var surahNames = [Int: SurahName]()
    @Published var hadithChapters = [UUID: HadithChapter]()

    private func loadHadithChapters(for highlights: [HadithHighlight]) {
        DispatchQueue.global().async {
            do {
                var chapters = [UUID: HadithChapter]()
                let collectorList = self.hadithRepo.getCollectorList()

                try highlights.forEach { bookmark in
                    guard let collector = collectorList.first(where:
                        { $0.contentId.contentId.getTitle() == bookmark.contentId.contentId.getTitle()
                        }
                    ) else { return }
                    let chapter =
                        try self.hadithRepo.getChapter(
                            collector: collector,
                            chapterNo: bookmark.chapterNo,
                            language: bookmark.contentId.lang
                        )
                    chapters[bookmark.id] = chapter
                }

                DispatchQueue.main.async {
                    self.hadithChapters += chapters
                }
            } catch {
                print(error)
            }
        }
    }

    private func loadHadithChapters(for bookmarks: [HadithBookmark]) {
        DispatchQueue.global().async {
            do {
                var chapters = [UUID: HadithChapter]()
                let collectorList = self.hadithRepo.getCollectorList()
                try bookmarks.forEach { bookmark in
                    guard let collector = collectorList.first(where:
                        { $0.contentId.contentId.getTitle() == bookmark.contentId.contentId.getTitle()
                        }
                    ) else { return }
                    let chapter =
                        try self.hadithRepo.getChapter(
                            collector: collector,
                            chapterNo: bookmark.chapterNo,
                            language: bookmark.contentId.lang
                        )
                    chapters[bookmark.id] = chapter
                }

                DispatchQueue.main.async {
                    self.hadithChapters += chapters
                }
            } catch {
                print(error)
            }
        }
    }

    func loadSurah() {
        if !surahNames.isEmpty { return }
        DispatchQueue.global().async {
            do {
                let surahList = try self.quranRepo.getSurahTransliteration(contentId: .en_tanzil, language: .en)
                let surahDict = surahList.reduce(into: [Int: SurahName]()) {
                    $0[$1.surahNo] = $1
                }
                DispatchQueue.main.async {
                    self.surahNames = surahDict
                }
            } catch {
                print(error)
            }
        }
    }

    func getBookmarks() {
        DispatchQueue.global().async {
            do {
                let hadithHighlights = try self.hadithNotebookRepository.getAllBookmarks()
                let quranHighlights = try self.quranNotebookRepository.getAllBookmarks()
                
                self.loadHadithChapters(for: hadithHighlights)

                DispatchQueue.main.async { [self] in
                    quranBookmarks.removeAll()
                    hadithBookmarks.removeAll()

                    self.quranBookmarks = quranHighlights
                    self.hadithBookmarks = hadithHighlights
                }

            } catch {
                print(error)
            }
        }
    }

    func getHighlights() {
        DispatchQueue.global().async {
            do {
                let hadithHighlights = try self.hadithNotebookRepository.getAllHighlights()
                let quranHighlights = try self.quranNotebookRepository.getAllHighlights()
                let tafsirHighlights = try self.tafsirNotebookRepository.getAllHighlights()
                
                self.loadHadithChapters(for: hadithHighlights)

                DispatchQueue.main.async {
                    self.hadithHighlights.removeAll()
                    self.quranHighlights.removeAll()
                    self.tafsirHighlights.removeAll()
                    self.hadithHighlights = hadithHighlights
                    self.quranHighlights = quranHighlights
                    self.tafsirHighlights = tafsirHighlights
                }
            } catch {
                print(error)
            }
        }
    }
}
