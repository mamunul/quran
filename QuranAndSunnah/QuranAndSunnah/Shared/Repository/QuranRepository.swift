//
//  QuranRepository.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 1/6/22.
//

import Foundation

class QuranRepository {
    static let shared = QuranRepository()

    private init() {}

//    private var quran: Quran?
    #if os(macOS)
        private let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
    #endif

    func surahNameTranslations(_ basePath: String, contentId: SurahTranslationID) -> [String: SurahTranslationJson] {
        let surahNameTranslationPath = contentId.getFilePath()
        #if os(iOS)
            let surahNameTranslationUrl = Bundle.main.url(forResource: surahNameTranslationPath, withExtension: "")!
        #else
            let surahNameTranslationUrl = homeDirectory.appendingPathComponent("\(basePath)\(surahNameTranslationPath)")
        #endif
        do {
            let data = try Data(contentsOf: surahNameTranslationUrl)
            let res = try JSONDecoder().decode([String: SurahTranslationJson].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func surahinfo(_ basePath: String, contentId: SurahNameContentID) -> [String: SurahJson] {
        let surahInfoPath = contentId.getFilePath()
        #if os(iOS)
            let surahInfoUrl = Bundle.main.url(forResource: surahInfoPath, withExtension: "")!
        #else
            let surahInfoUrl = homeDirectory.appendingPathComponent("\(basePath)\(surahInfoPath)")
        #endif
        do {
            let data = try Data(contentsOf: surahInfoUrl)
            let res = try JSONDecoder().decode([String: SurahJson].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllAyahTranslations(_ basePath: String, contentId: AyahTranslationID) -> [String: String] {
        let ayatTranslationPath = contentId.getFilePath()
        #if os(iOS)
            let ayatTranslationUrl = Bundle.main.url(forResource: ayatTranslationPath, withExtension: "")!
        #else
            let ayatTranslationUrl = homeDirectory.appendingPathComponent("\(basePath)\(ayatTranslationPath)")
        #endif
        do {
            let data = try Data(contentsOf: ayatTranslationUrl)
            let res = try JSONDecoder().decode(TranslationJson.self, from: data)
            return res.translations
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllAyahTransliterations(_ basePath: String, contentId: AyahTranslationID) -> [String: String] {
        let ayatTransliterationPath = contentId.getFilePath()
        #if os(iOS)
            let ayatTransliterationUrl = Bundle.main.url(forResource: ayatTransliterationPath, withExtension: "")!
        #else
            let ayatTransliterationUrl = homeDirectory.appendingPathComponent("\(basePath)\(ayatTransliterationPath)")
        #endif
        do {
            let data = try Data(contentsOf: ayatTransliterationUrl)
            let res = try JSONDecoder().decode([String: String].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllAyah(_ basePath: String, contentId: AyahContentID) -> [String: String] {
        let sarabicAyatPath = contentId.getFilePath()
        #if os(iOS)
            let arabicAyatUrl = Bundle.main.url(forResource: sarabicAyatPath, withExtension: "")!
        #else
            let arabicAyatUrl = homeDirectory.appendingPathComponent("\(basePath)\(sarabicAyatPath)")
        #endif
        do {
            let data = try Data(contentsOf: arabicAyatUrl)
            let res = try JSONDecoder().decode([String: String].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }
}

struct TranslationJson: Decodable {
    var translations: [String: String]
}

struct SurahJson: Decodable {
    var name: String
    var nAyah: Int
    var revelationOrder: Int
    var type: String
    var start: Int
    var end: Int
}

struct SurahTranslationJson: Decodable {
    var name: String
    var translation: String
}
