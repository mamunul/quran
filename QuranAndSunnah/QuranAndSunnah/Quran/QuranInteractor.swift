//
//  QuranInteractor.swift
//  QuranAndSunnah
//
//  Created by newone on 29/6/22.
//

import Foundation

actor QuranInteractor {
    private var repository: QuranJsonFacade
    private var notebookRepo: QuranNotebookRepository
    private var allAyah: [Ayah]

    init(repository: QuranJsonFacade = QuranJsonFacade.shared, notebookRepo: QuranNotebookRepository = QuranNotebookRepository()) {
        self.repository = repository
        self.notebookRepo = notebookRepo
        self.allAyah = []
    }

    func save(bookmark: QuranBookmark) throws {
        try notebookRepo.save(bookmark: bookmark)
    }

    func remove(bookmark: QuranBookmark) throws {
        try notebookRepo.remove(bookmark: bookmark)
    }

    nonisolated func getSurahList() async throws -> [SurahInfo] {
        let surahList = try await repository.getSurah()
        return surahList
    }

    nonisolated func getSurahTranslationList() async throws -> [SurahName] {
        let surahList = try await repository.getSurahTranslation(contentId: .en_tanzil, language: .en)
        return surahList
    }

    nonisolated func getSurahTransliterationList() async throws -> [SurahName] {
        let surahList = try await repository.getSurahTransliteration(contentId: .en_tanzil, language: .en)
        return surahList
    }

    nonisolated func getSurahArabicList() async throws -> [SurahName] {
        let surahList = try await repository.getSurahArabic(contentId: .en_unknown)
        return surahList
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

    nonisolated func getBookmark(ayah: Ayah) async throws -> QuranBookmark {
        let status = try await notebookRepo.getBookmark(for: ayah)
        return status
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

    nonisolated func getAyat(of surah: SurahInfo) async throws -> [Ayah] {
        let ayahList = try await repository.getAyat(of: surah, contentId: .indonesia_ar)
        return ayahList
    }

    nonisolated func getAyatTranslation(of surah: SurahInfo) async throws -> [Ayah] {
        let ayahList = try await repository.getAyahTranslation(of: surah, contentId: .en_hilali_quranenc, language: .en)
        return ayahList
    }

    nonisolated func getBookmarks(surah: SurahInfo) async throws -> [QuranBookmark] {
        let bookmarksList = try await notebookRepo.getBookmarks(for: surah)
        return bookmarksList
    }

    nonisolated func getHighlights(of surah: SurahInfo) async throws -> [QuranHighlight] {
        let hadithHighlights = try await notebookRepo.getHighlights(for: surah)
        return hadithHighlights
    }

    nonisolated func getHighlights(for ayah: Ayah) async throws -> [QuranHighlight] {
        try await notebookRepo.getHighlights(for: ayah)
    }

    func save(highlights: [QuranHighlight], for ayah: Ayah) throws {
        try notebookRepo.save(highlights: highlights, for: ayah)
    }

    func remove(highlight: QuranHighlight) throws {
        try notebookRepo.remove(highlight: highlight)
    }
}
