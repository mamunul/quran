//
//  HadithPresenter.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import Foundation

class HadithPresenter: ObservableObject {
    @Published var collectors = [HadithCollector]()
    private var repo: IHadithDataReadFacade = HadithRepository()
    private var notebookRepo = HadithNotebookRepository()

    func bookmark(hadith: HadithText, _ add: Bool) {
        do {
            let bookmark =
                HadithBookmark(hadithNo: hadith.hadithNo, chapterNo: hadith.chapterNo, contentId: hadith.contentId)
            if add {
                try notebookRepo.save(bookmark: bookmark)
            } else {
                try notebookRepo.remove(bookmark: bookmark)
            }
        } catch {
            print(error)
        }
    }

    func getBookmarks(of chapter: HadithChapter) -> [Int: Bool] {
        var bookmarks = [Int: Bool]()

        chapter.hadithNo.forEach { hadithNo in
            bookmarks[hadithNo] = false
        }
        do {
            let bookmarksList = try notebookRepo.getBookmarks(for: chapter)

            bookmarksList.forEach { bookmark in
                bookmarks[bookmark.hadithNo] = true
            }
        } catch {
            print(error)
        }
        return bookmarks
    }

    func isBookmarked(hadith: HadithText) -> Bool {
        do {
            let status = try notebookRepo.getBookmark(for: hadith) != .empty
            return status
        } catch {
            print(error)
        }
        return false
    }

    func getHighlights(of chapter: HadithChapter) -> [Int: [Highlight]] {
        var highlightsDict = [Int: [Highlight]]()
        chapter.hadithNo.forEach { hadithNo in
            highlightsDict[hadithNo] = [Highlight]()
        }
        do {
            let hadithHighlights = try notebookRepo.getHighlights(for: chapter)

            hadithHighlights.forEach { hadithHighlight in

                let highlight = Highlight(
                    id: UUID(),
                    range: hadithHighlight.markedRange,
                    markedText: hadithHighlight.highlightedText,
                    chapterTitle: "Chapter:\(hadithHighlight.chapterNo)",
                    contentNo: "HadithNo:\(hadithHighlight.hadithNo)",
                    bookName: "Hadith:\(hadithHighlight.contentId.contentId.getFilePath())",
                    type: .hadith
                )
                highlightsDict[hadithHighlight.hadithNo]?.append(highlight)
            }
        } catch {
            print(error)
        }

        return highlightsDict
    }

    func getHighlights(of hadith: HadithText) -> [Highlight] {
        var highlights = [Highlight]()
        do {
            let hadithHighlights = try notebookRepo.getHighlights(for: hadith)
            highlights = hadithHighlights.map { hadithHighlight in
                Highlight(
                    range: hadithHighlight.markedRange,
                    markedText: hadithHighlight.highlightedText,
                    chapterTitle: "Chapter:\(hadithHighlight.chapterNo)",
                    contentNo: "HadithNo:\(hadithHighlight.hadithNo)",
                    bookName: "Hadith:\(hadithHighlight.contentId.contentId.getFilePath())",
                    type: .hadith
                )
            }
        } catch {
            print(error)
        }

        return highlights
    }

    func remove(highlight: Highlight, from hadith: HadithText) {
        let quranHighlight =
            HadithHighlight(
                markedRange: highlight.range,
                highlightedText: highlight.markedText,
                hadithNo: hadith.hadithNo,
                chapterNo: hadith.chapterNo,
                contentId: hadith.contentId
            )
        do {
            try notebookRepo.remove(highlight: quranHighlight)
        } catch {
            print(error)
        }
    }

    func onHighlightEvent(hadith: HadithText, textRange: ClosedRange<Int>) {
//        print(textRange)

        let attributedContent = NSMutableAttributedString(string: hadith.matn)

        let markedString = attributedContent.attributedSubstring(from: NSRange(textRange)).string

        do {
            var ayatHighlights: [IHighlight] = try notebookRepo.getHighlights(for: hadith)

            let highlight =
                HadithHighlight(
                    markedRange: textRange,
                    highlightedText: markedString,
                    hadithNo: hadith.hadithNo,
                    chapterNo: hadith.chapterNo,
                    contentId: hadith.contentId
                )

            ayatHighlights.append(highlight)
            MergeVisitor().mergeOverlapped(collection: &ayatHighlights)

            try notebookRepo.save(highlights: ayatHighlights as! [HadithHighlight], of: hadith)
        } catch {
            print(error)
        }
    }

    func getHadithCollectorList() {
        collectors = repo.getCollectorList()
    }

    func getChapterList(collector: HadithCollector) -> [HadithChapter] {
        repo.getChapterList(of: collector, language: .en)
    }

    func getHadithArabicList(of chapter: HadithChapter, collector: HadithCollector) -> [Int: HadithText] {
        do {
            let list = try repo.getHadithList(of: chapter, collector: collector, language: .ar)

            let dict = list.reduce(into: [Int: HadithText]()) {
                $0[$1.hadithNo] = $1
            }
            return dict
        } catch {
            print(error)
            return [:]
        }
    }

    func getHadithEnglishList(of chapter: HadithChapter, collector: HadithCollector) -> [HadithText] {
        do {
            let list = try repo.getHadithList(of: chapter, collector: collector, language: .en)
            return list
        } catch {
            print(error)
            return []
        }
    }
}
