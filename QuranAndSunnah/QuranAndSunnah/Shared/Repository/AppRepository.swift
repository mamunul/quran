//
//  Repository.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 1/6/22.
//

import Foundation

class AppRepository {
}

class QuranRepository {
    let arabicAyah = "indonesia.json"

    let englishTranslation1 = "ayah-translation/en-hilali-quranenc.json"
    let englishTranslation2 = "ayah-translation/en-sarwar-tanzil.json"
    let englishTranslation3 = "ayah-translation/en-itani-tanzil.json"
    let banglaTranslation1 = "ayah-translation/bn-bengali-tanzil.json"
    let englishTransliteration = "ayah-transliteration/id-litequran.json"
    let surahTranslation = "surah-translation/en-tanzil.json"
    let surahInfo = "surah/surah.json"
    let wordEnglishTranslation = "word-translation/en-wbw.json"
    let wordBanglaTranslation = "word-translation/bn-wbw.json"
    let wordEnglishTransliteration = "word-transliteration/en-quranwbw.json"

    func test() -> [String: SurahTranslationJson] {
        return [:]
    }
    
    func surahNameTranslations() -> [String: SurahTranslationJson] {
        do {
            let url = Bundle.main.url(forResource: "en-tanzil.json", withExtension: "")!
            let data = try Data(contentsOf: url)
            let res = try JSONDecoder().decode([String: SurahTranslationJson].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func surahinfo() -> [String: SurahJson] {
        do {
            let url = Bundle.main.url(forResource: "surah.json", withExtension: "")!
            let data = try Data(contentsOf: url)
            let res = try JSONDecoder().decode([String: SurahJson].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllTranslations() -> [String: String] {
        do {
            let url = Bundle.main.url(forResource: "en-ahmedali-tanzil.json", withExtension: "")!
            let data = try Data(contentsOf: url)
            let res = try JSONDecoder().decode(Translations.self, from: data)
            return res.translations
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllAyahTransliterations() -> [String: String] {
        do {
            let url = Bundle.main.url(forResource: "id-litequran.json", withExtension: "")! // URL(string: "indonesia.json")!
            let data = try Data(contentsOf: url)
            let res = try JSONDecoder().decode([String: String].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }

    func getAllAyah() -> [String: String] {
        do {
            let url = Bundle.main.url(forResource: "indonesia.json", withExtension: "")! // URL(string: "indonesia.json")!
            let data = try Data(contentsOf: url)
            let res = try JSONDecoder().decode([String: String].self, from: data)
            return res
        } catch {
            print(error)
        }
        return [:]
    }
}

struct Translations: Decodable {
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
