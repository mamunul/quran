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
    
    func getHighlights(of hadith: HadithText) -> [Highlight] {
        var highlights = [Highlight]()
        do {
            let hadithHighlights = try notebookRepo.getHighlights(for: hadith)

            highlights = hadithHighlights.map { hadith in
                Highlight(
                    id: UUID(),
                    range: hadith.range,
                    markedText: hadith.highlightedText,
                    chapterTitle: "Chapter:\(hadith.chapterNo)",
                    contentNo: "HadithNo:\(hadith.hadithNo)",
                    bookName: "Hadith:\(hadith.contentId.contentId.getFilePath())"
                )
            }
            
        } catch {
            print(error)
        }

        return highlights
    }

    func onHighlightEvent(hadith: HadithText, textRange: ClosedRange<Int>) {
//        print(textRange)

        let attributedContent = NSMutableAttributedString(string: hadith.matn)

        let markedString = attributedContent.attributedSubstring(from: NSRange(textRange)).string
        let highlight =
            HadithHighlight(
                range: textRange,
                highlightedText: markedString,
                hadithNo: hadith.hadithNo,
                chapterNo: hadith.chapterNo,
                contentId: hadith.contentId
            )
        do {
            try notebookRepo.save(highlight: highlight)
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
