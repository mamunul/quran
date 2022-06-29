//
//  QuranPresenter.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import Foundation

@MainActor
class QuranPresenter: ObservableObject {
    @Published var surahList = [SurahInfo]()
    @Published var surahArabicList = [Int: SurahName]()
    @Published var surahTranslationList = [Int: SurahName]()
    @Published var surahTranslilerationList = [Int: SurahName]()
//    @Published var surah: SurahInfo?
//    private var repository = QuranJsonFacade.shared
//    private var notebookRepo = QuranNotebookRepository()
    private var interactor = QuranInteractor()

    func bookmark(ayah: Ayah, _ add: Bool) async {
        do {
            let bookmark = QuranBookmark(ayatNo: ayah.ayahNo, surahNo: ayah.surahNo, contentId: ayah.contentId)
            if add {
                try await interactor.save(bookmark: bookmark)
            } else {
                try await interactor.remove(bookmark: bookmark)
            }
        } catch {
            print(error)
        }
    }

    func getBookmarks(surah: SurahInfo) async -> [Int: Bool] {
        var bookmarks = [Int: Bool]()
        do {
            (surah.firstAyahNo ... surah.lastAyahNo).forEach { ayahNo in
                bookmarks[ayahNo] = false
            }
            let bookmarksList = try await interactor.getBookmarks(surah: surah)

            bookmarksList.forEach { bookmark in
                bookmarks[bookmark.ayatNo] = true
            }
        } catch {
            print(error)
        }
        return bookmarks
    }

    func isBookmarked(ayah: Ayah) async -> Bool {
        do {
            let status = try await interactor.getBookmark(ayah: ayah) != .empty
            return status
        } catch {
            print(error)
        }
        return false
    }

    func getHighlights(of surah: SurahInfo) async -> [Int: [Highlight]] {
        var highlightsDict = [Int: [Highlight]]()
        (surah.firstAyahNo ... surah.lastAyahNo).forEach { ayatNo in
            highlightsDict[ayatNo] = [Highlight]()
        }

        do {
            let hadithHighlights = try await interactor.getHighlights(of: surah)

            hadithHighlights.forEach { hadithHighlight in

                let highlight = Highlight(
                    range: hadithHighlight.markedRange,
                    markedText: hadithHighlight.highlightedText,
                    chapterTitle: "AyatNo:\(hadithHighlight.ayatNo)",
                    contentNo: "Surah:\(hadithHighlight.surahNo)",
                    bookName: "Quran:\(hadithHighlight.contentId.contentId.getFilePath())",
                    type: .quran
                )
                highlightsDict[hadithHighlight.ayatNo]?.append(highlight)
            }
        } catch {
            print(error)
        }

        return highlightsDict
    }

    func getHighlights(of ayah: Ayah) async -> [Highlight] {
        var highlights = [Highlight]()
        do {
            let quranHighlights = try await interactor.getHighlights(for: ayah)

            highlights = quranHighlights.map { hadith in
                Highlight(
                    range: hadith.markedRange,
                    markedText: hadith.highlightedText,
                    chapterTitle: "AyatNo:\(hadith.ayatNo)",
                    contentNo: "Surah:\(hadith.surahNo)",
                    bookName: "Quran:\(hadith.contentId.contentId.getFilePath())",
                    type: .quran
                )
            }
        } catch {
            print(error)
        }

        return highlights
    }

    func remove(highlight: Highlight, from ayah: Ayah) async {
        let quranHighlight =
            QuranHighlight(
                markedRange: highlight.range,
                highlightedText: highlight.markedText,
                ayatNo: ayah.ayahNo,
                surahNo: ayah.surahNo,
                contentId: ayah.contentId
            )
        do {
            try await interactor.remove(highlight: quranHighlight)
        } catch {
            print(error)
        }
    }

    func onHighlightEvent(textRange: ClosedRange<Int>, ayah: Ayah, fullString: String) async {
        let attributedContent = NSMutableAttributedString(string: fullString)
        let markedString = attributedContent.attributedSubstring(from: NSRange(textRange)).string

        do {
            var ayatHighlights: [IHighlight] = try await interactor.getHighlights(for: ayah)

            let highlight =
                QuranHighlight(
                    markedRange: textRange,
                    highlightedText: markedString,
                    ayatNo: ayah.ayahNo,
                    surahNo: ayah.surahNo,
                    contentId: ayah.contentId
                )

            ayatHighlights.append(highlight)
            MergeVisitor().mergeOverlapped(collection: &ayatHighlights)

            try await interactor.save(highlights: ayatHighlights as! [QuranHighlight], for: ayah)
        } catch {
            print(error)
        }
    }

    func getSurahList() async {
        do {
            let surahList = try await interactor.getSurahList()
            self.surahList = surahList
        } catch {
            print(error)
        }
    }

    func getSurahArabicList() async {
        do {
            let list = try await interactor.getSurahArabicList()

            let dict = list.reduce(into: [Int: SurahName]()) {
                $0[$1.surahNo] = $1
            }
            surahArabicList = dict

        } catch {
            print(error)
        }
    }

    func getSurahTransliterationList() async {
        do {
            let list = try await interactor.getSurahTransliterationList()

            let dict = list.reduce(into: [Int: SurahName]()) {
                $0[$1.surahNo] = $1
            }
            surahTranslilerationList = dict
        } catch {
            print(error)
        }
    }

    func getSurahTranslationList() async {
        do {
            let surahTranslationList1 = try await interactor.getSurahTranslationList()

            let dict = surahTranslationList1.reduce(into: [Int: SurahName]()) {
                $0[$1.surahNo] = $1
            }
            surahTranslationList = dict
        } catch {
            print(error)
        }
    }

    func getAyat(of surah: SurahInfo) async throws -> [Ayah] {
        do {
            let ayahList = try await interactor.getAyat(of: surah)
            return ayahList
        } catch {
            print(error)
        }
        return []
    }

    func getAyatTranslation(of surah: SurahInfo) async throws -> [Int: Ayah] {
        do {
            let list = try await interactor.getAyatTranslation(of: surah)

            let dict = list.reduce(into: [Int: Ayah]()) {
                $0[$1.ayahNo] = $1
            }
            return dict
        } catch {
            print(error)
        }
        return [:]
    }

    func searchInSurahAndAyat(searchString: String) async -> [SurahInfo] {
        var filtered = [SurahInfo]()
        do {
            filtered = try await interactor.searchInSurahAndAyat(
                searchString: searchString,
                surahList: surahList,
                surahTranslationList: surahTranslationList,
                surahTranslilerationList: surahTranslilerationList
            )
        } catch {
            print(error)
        }

        return filtered
    }
}
