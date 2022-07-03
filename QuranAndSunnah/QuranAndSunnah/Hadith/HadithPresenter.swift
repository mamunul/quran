//
//  HadithPresenter.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import Foundation
import QuartzCore

@MainActor
class HadithPresenter: ObservableObject {
    @Published var collectors = [HadithCollector]()
    private var interactor = HadithInteractor()

    init(collectors: [HadithCollector] = [HadithCollector](), interactor: HadithInteractor = HadithInteractor()) {
        self.collectors = collectors
        self.interactor = interactor
    }

    func search(in chapterList: [HadithChapter], collector: HadithCollector, searchString: String) -> [HadithChapter] {
        var chapters = [HadithChapter]()
        do {
            chapters = try interactor.search(in: chapterList, collector: collector, searchString: searchString)
        } catch {
            print(error)
        }

        return chapters
    }

    func bookmark(hadith: HadithText, _ add: Bool) {
        do {
            let bookmark =
                HadithBookmark(hadithNo: hadith.hadithNo, chapterNo: hadith.chapterNo, contentId: hadith.contentId)
            if add {
                try interactor.save(bookmark: bookmark)
            } else {
                try interactor.delete(bookmark: bookmark)
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
            let bookmarksList = try interactor.getBookmarks(of: chapter)

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
            let status = try interactor.isBookmarked(hadith: hadith)
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
            let hadithHighlights = try interactor.getHighlights(of: chapter)

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
            let hadithHighlights = try interactor.getHighlights(of: hadith)
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
            try interactor.remove(highlight: quranHighlight)
        } catch {
            print(error)
        }
    }

    func onHighlightEvent(hadith: HadithText, textRange: ClosedRange<Int>) {
//        print(textRange)

        let attributedContent = NSMutableAttributedString(string: hadith.matn)

        let markedString = attributedContent.attributedSubstring(from: NSRange(textRange)).string

        do {
            var ayatHighlights: [IHighlight] = try interactor.getHighlights(of: hadith)

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

            try interactor.save(highlights: ayatHighlights as! [HadithHighlight], of: hadith)
        } catch {
            print(error)
        }
    }

    func getHadithCollectorList() {
        collectors = interactor.getHadithCollectorList()
    }

    func getChapterList(collector: HadithCollector) async -> [HadithChapter] {
        do {
            return try await interactor.getChapterList(collector: collector)
        } catch {
            print(error)
        }
        return []
    }

    func getHadithArabicList(of chapter: HadithChapter, collector: HadithCollector) -> [Int: HadithText] {
        do {
            let list = try interactor.getHadithArabicList(of: chapter, collector: collector)

            let dict = list.reduce(into: [Int: HadithText]()) {
                $0[$1.hadithNo] = $1
            }
            return dict
        } catch {
            print(error)
            return [:]
        }
    }

    nonisolated func getHeights(of hadithArabicList: [HadithText], fontSize: Double, viewWidth: CGFloat) async -> [Int: CGSize] {
        var heights = [Int: CGSize]()
        let calculator = TextViewFrameCalculator2()
        let taskNo = taskCount
        let step = hadithArabicList.count / taskNo

        heights = await withTaskGroup(of: [Int: CGSize].self) { group in
            var gheights = [Int: CGSize]()
            for index in stride(from: 0, to: hadithArabicList.count, by: step) {
                group.addTask {
                    var subheights = [Int: CGSize]()
                    for index2 in index ... min(index + step, hadithArabicList.count - 1) {
                        let hadith = hadithArabicList[index2]

                        let size = await calculator.frameSize(
                            for: hadith.matn,
                            fontSize: Int(fontSize),
                            width: viewWidth,
                            paragraphAlignment: .left
                        )

                        subheights[hadith.hadithNo] = size
                    }
                    return subheights
                }
            }

            for await result in group {
                gheights += result
            }
            return gheights
        }
        return heights
    }

    private let taskCount = 10

    nonisolated func getHeights(of hadithArabicList: [Int: HadithText], fontSize: Double, viewWidth: CGFloat) async -> [Int: CGSize] {
        var heights = [Int: CGSize]()
        let calculator = TextViewFrameCalculator2()

        let taskNo = taskCount
        let step = hadithArabicList.count / taskNo

        let allKeys = Array(hadithArabicList.keys)

        heights = await withTaskGroup(of: [Int: CGSize].self) { group in
            var gheights = [Int: CGSize]()
            for index in stride(from: 0, to: hadithArabicList.count, by: step) {
                group.addTask {
                    var subheights = [Int: CGSize]()
                    for index2 in index ... min(index + step, hadithArabicList.count - 1) {
                        let hadith = hadithArabicList[allKeys[index2]]!

                        let size = await calculator.frameSize(
                            for: hadith.matn,
                            fontSize: Int(fontSize),
                            width: viewWidth,
                            paragraphAlignment: .right
                        )

                        subheights[hadith.hadithNo] = size
                    }
                    return subheights
                }
            }

            for await result in group {
                gheights += result
            }
            return gheights
        }
        return heights
    }

    func getHadithEnglishList(of chapter: HadithChapter, collector: HadithCollector) -> [HadithText] {
        do {
            let list = try interactor.getHadithEnglishList(of: chapter, collector: collector)
            return list
        } catch {
            print(error)
            return []
        }
    }
}
