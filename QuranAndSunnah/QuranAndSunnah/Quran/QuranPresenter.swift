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
    
    func bookmark(ayah: Ayah) {
        do {
            let bookmark = QuranBookmark(ayatNo: ayah.ayahNo, surahNo: ayah.surahNo, contentId: ayah.contentId)
            try notebookRepo.save(bookmark: bookmark)
        } catch {
            print(error)
        }
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

    func onHighlightEvent(textRange: ClosedRange<Int>, ayah: Ayah, text: String) {
//        print(textRange)
        let attributedContent = NSMutableAttributedString(string: text)
        let markedString = attributedContent.attributedSubstring(from: NSRange(textRange)).string
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
