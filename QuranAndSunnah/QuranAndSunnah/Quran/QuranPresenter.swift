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
    private var repository = QuranJsonFacade.shared
    private var notebookRepo = QuranNotebookRepository()
    private var interactor = QuranInteractor()

    func bookmark(ayah: Ayah, _ add: Bool) {
        do {
            let bookmark = QuranBookmark(ayatNo: ayah.ayahNo, surahNo: ayah.surahNo, contentId: ayah.contentId)
            if add {
                try notebookRepo.save(bookmark: bookmark)
            } else {
                try notebookRepo.remove(bookmark: bookmark)
            }
        } catch {
            print(error)
        }
    }

    func getBookmarks(surah: SurahInfo) -> [Int: Bool] {
        var bookmarks = [Int: Bool]()

        (surah.firstAyahNo ... surah.lastAyahNo).forEach { ayahNo in
            bookmarks[ayahNo] = false
        }
        do {
            let bookmarksList = try notebookRepo.getBookmarks(for: surah)

            bookmarksList.forEach { bookmark in
                bookmarks[bookmark.ayatNo] = true
            }
        } catch {
            print(error)
        }
        return bookmarks
    }

    func isBookmarked(ayah: Ayah) -> Bool {
        do {
            let status = try notebookRepo.getBookmark(for: ayah) != .empty
            return status
        } catch {
            print(error)
        }
        return false
    }

    func getHighlights(of surah: SurahInfo) -> [Int: [Highlight]] {
        var highlightsDict = [Int: [Highlight]]()
        (surah.firstAyahNo ... surah.lastAyahNo).forEach { ayatNo in
            highlightsDict[ayatNo] = [Highlight]()
        }

        do {
            let hadithHighlights = try notebookRepo.getHighlights(for: surah)

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

    func getHighlights(of ayah: Ayah) -> [Highlight] {
        var highlights = [Highlight]()
        do {
            let quranHighlights = try notebookRepo.getHighlights(for: ayah)

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

    func remove(highlight: Highlight, from ayah: Ayah) {
        let quranHighlight =
            QuranHighlight(
                markedRange: highlight.range,
                highlightedText: highlight.markedText,
                ayatNo: ayah.ayahNo,
                surahNo: ayah.surahNo,
                contentId: ayah.contentId
            )
        do {
            try notebookRepo.remove(highlight: quranHighlight)
        } catch {
            print(error)
        }
    }

    func onHighlightEvent(textRange: ClosedRange<Int>, ayah: Ayah, fullString: String) {
        let attributedContent = NSMutableAttributedString(string: fullString)
        let markedString = attributedContent.attributedSubstring(from: NSRange(textRange)).string

        do {
            var ayatHighlights: [IHighlight] = try notebookRepo.getHighlights(for: ayah)

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

            try notebookRepo.save(highlights: ayatHighlights as! [QuranHighlight], for: ayah)
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
            let dict = try await interactor.getSurahArabicList()
            surahArabicList = dict

        } catch {
            print(error)
        }
    }

    func getSurahTransliterationList() async {
        do {
            let dict = try await interactor.getSurahTransliterationList()
            surahTranslilerationList = dict
        } catch {
            print(error)
        }
    }

    func getSurahTranslationList() async {
        do {
            let dict = try await interactor.getSurahTranslationList()
            surahTranslationList = dict
        } catch {
            print(error)
        }
    }

    func getAyat(of surah: SurahInfo) -> [Ayah] {
        do {
            let ayahList = try repository.getAyat(of: surah, contentId: .indonesia_ar)
            return ayahList
        } catch {
            print(error)
        }
        return []
    }

    func getAyatTranslation(of surah: SurahInfo) -> [Int: Ayah] {
        do {
            let ayahList = try repository.getAyahTranslation(of: surah, contentId: .en_hilali_quranenc, language: .en)

            let dict = ayahList.reduce(into: [Int: Ayah]()) {
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

actor QuranInteractor {
    private var repository: QuranJsonFacade
    private var notebookRepo: QuranNotebookRepository
    private var allAyah: [Ayah]

    init(repository: QuranJsonFacade = QuranJsonFacade.shared, notebookRepo: QuranNotebookRepository = QuranNotebookRepository()) {
        self.repository = repository
        self.notebookRepo = notebookRepo
        self.allAyah = []
    }

    nonisolated func getSurahList() async throws -> [SurahInfo] {
        let surahList = try await repository.getSurah()
        return surahList
    }

    nonisolated func getSurahTranslationList() async throws -> [Int: SurahName] {
        let surahList = try await repository.getSurahTranslation(contentId: .en_tanzil, language: .en)

        let dict = surahList.reduce(into: [Int: SurahName]()) {
            $0[$1.surahNo] = $1
        }
        return dict
    }

    nonisolated func getSurahTransliterationList() async throws -> [Int: SurahName] {
        let surahList = try await repository.getSurahTransliteration(contentId: .en_tanzil, language: .en)

        let dict = surahList.reduce(into: [Int: SurahName]()) {
            $0[$1.surahNo] = $1
        }
        return dict
    }

    nonisolated func getSurahArabicList() async throws -> [Int: SurahName] {
        let surahList = try await repository.getSurahArabic(contentId: .en_unknown)

        let dict = surahList.reduce(into: [Int: SurahName]()) {
            $0[$1.surahNo] = $1
        }
        return dict
    }

    func searchInSurahAndAyat(
        searchString: String,
        surahList: [SurahInfo],
        surahTranslationList: [Int: SurahName],
        surahTranslilerationList: [Int: SurahName]
    ) async throws -> [SurahInfo] {
        var filtered = [SurahInfo]()

        if allAyah.isEmpty {
            let allAyat = try repository.getAllAyat(contentId: .en_hilali_quranenc, surahList: surahList)
            self.allAyah = allAyat
        }
        let searchStringLC = searchString.lowercased()

        var setOfSurah = Set<SurahInfo>()

        filterbySurahNames(
            searchStringLC,
            surahList: surahList,
            surahTranslationList: surahTranslationList,
            surahTranslilerationList: surahTranslilerationList
        ).forEach { surah in
            setOfSurah.insert(surah)
        }

        allAyah.forEach { ayah in
            if ayah.text.lowercased().contains(searchStringLC) {
                if let first = surahList.first(where: { surah in
                    surah.surahNo == ayah.surahNo
                }) {
                    setOfSurah.insert(first)
                }
            }
        }

        filtered = Array(setOfSurah)

        return filtered
    }

    func filterbySurahNames(
        _ searchString: String,
        surahList: [SurahInfo],
        surahTranslationList: [Int: SurahName],
        surahTranslilerationList: [Int: SurahName]
    ) -> [SurahInfo] {
        let searchStringLC = searchString.lowercased()
        let filtered = surahList.filter { surah in
            searchInSurahNames(
                searchStringLC: searchStringLC,
                in: surah,
                surahTranslationList: surahTranslationList,
                surahTranslilerationList: surahTranslilerationList
            )
        }

        return filtered
    }

    private func searchInSurahNames(
        searchStringLC: String,
        in surah: SurahInfo,
        surahTranslationList: [Int: SurahName],
        surahTranslilerationList: [Int: SurahName]
    ) -> Bool {
        surahTranslationList[surah.surahNo]?.text.lowercased().contains(searchStringLC) ?? false
            ||
            surahTranslilerationList[surah.surahNo]?.text.lowercased().contains(searchStringLC) ?? false
    }
}
