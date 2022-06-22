//
//  QuranPresenter.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import Foundation

class QuranPresenter: ObservableObject {
    @Published var surahList = [SurahInfo]()
    @Published var surahArabicList = [Int: SurahName]()
    @Published var surahTranslationList = [Int: SurahName]()
    @Published var surahTranslilerationList = [Int: SurahName]()
//    @Published var surah: SurahInfo?
    private var repository = QuranJsonFacade.shared
    private var notebookRepo = QuranNotebookRepository()

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
                    id: UUID(),
                    range: hadithHighlight.range,
                    markedText: hadithHighlight.highlightedText,
                    chapterTitle: "AyatNo:\(hadithHighlight.ayatNo)",
                    contentNo: "Surah:\(hadithHighlight.surahNo)",
                    bookName: "Quran:\(hadithHighlight.contentId.contentId.getFilePath())"
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
                    id: UUID(),
                    range: hadith.range,
                    markedText: hadith.highlightedText,
                    chapterTitle: "AyatNo:\(hadith.ayatNo)",
                    contentNo: "Surah:\(hadith.surahNo)",
                    bookName: "Quran:\(hadith.contentId.contentId.getFilePath())"
                )
            }
        } catch {
            print(error)
        }

        return highlights
    }

    func onHighlightEvent(textRange: ClosedRange<Int>, ayah: Ayah, markedString: String) {
//        print(textRange)

        let highlight =
            QuranHighlight(
                range: textRange,
                highlightedText: markedString,
                ayatNo: ayah.ayahNo,
                surahNo: ayah.surahNo,
                contentId: ayah.contentId
            )
        do {
            try notebookRepo.save(highlight: highlight)
        } catch {
            print(error)
        }
    }

    func getSurahList() {
        do {
            let surahList = try repository.getSurah()
            self.surahList = surahList
//            surah = surahList.first
        } catch {
            print(error)
        }
    }

    func getSurahArabicList() {
        do {
            let surahList = try repository.getSurahArabic(contentId: .en_unknown)

            let dict = surahList.reduce(into: [Int: SurahName]()) {
                $0[$1.surahNo] = $1
            }
            surahArabicList = dict
        } catch {
            print(error)
        }
    }

    func getSurahTransliterationList() {
        do {
            let surahList = try repository.getSurahTransliteration(contentId: .en_tanzil, language: .en)

            let dict = surahList.reduce(into: [Int: SurahName]()) {
                $0[$1.surahNo] = $1
            }
            surahTranslilerationList = dict
        } catch {
            print(error)
        }
    }

    func getSurahTranslationList() {
        do {
            let surahList = try repository.getSurahTranslation(contentId: .en_tanzil, language: .en)

            let dict = surahList.reduce(into: [Int: SurahName]()) {
                $0[$1.surahNo] = $1
            }
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
}
