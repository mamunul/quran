//
//  SearchPresenter.swift
//  QuranAndSunnah
//
//  Created by newone on 27/6/22.
//

import Foundation

enum SearchType: String {
    case hadith, quran, tafsir, all
}

class SearchPresenter: ObservableObject {
    @Published var searchSelection = SearchType.quran
    @Published var searchString = ""
    private var repository = QuranJsonFacade.shared
    private var hadithRepository = HadithRepository()

    private var hadithList = [HadithText]()
    private var ayat = [Ayah]()
    private var surahTranslilerationList = [Int: SurahName]()
    private var surahList = [SurahInfo]()

    func getHadithCollectorList() -> [HadithCollector] {
        hadithRepository.getCollectorList()
    }

    func getHadithList(of collector: HadithCollector) async -> [HadithText] {
        if !hadithList.isEmpty {
            return hadithList
        }
        var allList = [HadithText]()
        do {
            allList = try await hadithRepository.getAllHadith(of: collector)
        } catch {
            print(error)
        }
        hadithList = allList
        return allList
    }

    func getHadithList() async -> [HadithText] {
        if !hadithList.isEmpty {
            return hadithList
        }
        var allList = [HadithText]()
        do {
            allList = try await hadithRepository.getAllHadith()
        } catch {
            print(error)
        }
        hadithList = allList
        return allList
    }

    func getSurahTransliterationList() -> [Int: SurahName] {
        if !surahTranslilerationList.isEmpty {
            return surahTranslilerationList
        }
        do {
            let surahList = try repository.getSurahTransliteration(contentId: .en_tanzil, language: .en)

            let dict = surahList.reduce(into: [Int: SurahName]()) {
                $0[$1.surahNo] = $1
            }

            surahTranslilerationList = dict

        } catch {
            print(error)
        }

        return surahTranslilerationList
    }

    func getSurahList() -> [SurahInfo] {
        if !surahList.isEmpty {
            return surahList
        }
        do {
            let surahList = try repository.getSurah()

            self.surahList = surahList

        } catch {
            print(error)
        }

        return surahList
    }

    func getAyatTranslation() -> [Ayah] {
        if !ayat.isEmpty {
            return ayat
        }
        var ayat = [Ayah]()
        do {
            surahList = getSurahList()
            ayat = try repository.getAllAyat(contentId: .en_hilali_quranenc, surahList: surahList)
        } catch {
            print(error)
        }
        self.ayat = ayat
        return ayat
    }
}
