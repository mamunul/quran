//
//  Repository.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 1/6/22.
//

import Foundation

class AppRepository {
}

struct HadithJson {
    var chapter_number: Int
    var chapter_english: String
    var chapter_arabic: String
    var section_number: Int
    var section_english: String
    var section_arabic: String
    var hadith_number: Int
    var english_hadith: String
    var english_isnad: String
    var english_matn: String
    var arabic_hadith: String
    var arabic_isnad: String
    var arabic_matn: String
    var arabic_comment: String
    var english_grade: String
    var arabic_grad: String
}

class HadithRepository {
    func test() -> String {
        // Chapter_Number,Chapter_English,Chapter_Arabic,Section_Number,Section_English,Section_Arabic,Hadith_number,English_Hadith,English_Isnad,English_Matn,Arabic_Hadith,Arabic_Isnad,Arabic_Matn,Arabic_Comment,English_Grade,Arabic_Grade
        do {
            let fileUrl = Bundle.main.url(forResource: "Hadith/AbuDaud/Chapter1.csv", withExtension: "")!
            let data = try Data(contentsOf: fileUrl)
            let content = String(data: data, encoding: .utf8)
            var hadithList = [HadithJson]()
            var firstLine = true
            content?.enumerateLines(invoking: { line, _ in

                if firstLine { firstLine = false; return }

                let strs = line.split(separator: ",", omittingEmptySubsequences: false)
                let hadith =
                    HadithJson(
                        chapter_number: Int(Float(strs[0])!),
                        chapter_english: String(strs[1]),
                        chapter_arabic: String(strs[2]),
                        section_number: Int(Float(strs[3])!),
                        section_english: String(strs[4]),
                        section_arabic: String(strs[5]),
                        hadith_number: Int(Float(strs[6])!),
                        english_hadith: String(strs[7]),
                        english_isnad: String(strs[8]),
                        english_matn: String(strs[9]),
                        arabic_hadith: String(strs[10]),
                        arabic_isnad: String(strs[11]),
                        arabic_matn: String(strs[12]),
                        arabic_comment: String(strs[13]),
                        english_grade: String(strs[14]),
                        arabic_grad: String(strs[14])
                    )
                hadithList.append(hadith)
                print(hadith)
            })
        } catch {
        }
        return ""
    }
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

    func requestQuran() -> Quran {
        let surahNammeTranslationJson = surahNameTranslations()
        let surahInfoJson = surahinfo()
        let translationsJson = getAllTranslations()
        let transliterationnJson = getAllTranslations()
//        let transliterationnJson = getAllAyahTransliterations()
        let ayah = getAllAyah()

        var ayahList = [Ayah]()

        for (ayahAr, (ayahTranslation, ayahTrannsliteration)) in zip(ayah, zip(translationsJson, transliterationnJson)) {
            let translation = Translation(lang: .en, translation: ayahTranslation.value)
            let transliteration = Transliteration(lang: .en, transliteration: ayahTrannsliteration.value)
            let ayah =
                Ayah(ayahNo: Int(ayahAr.key)!,
                     arabic: ayahAr.value,
                     translations: [translation],
                     transliterations: [transliteration],
                     words: [Word](),
                     bookmark: false,
                     tags: [String]()
                )

            ayahList.append(ayah)
        }

        var surahList = [Surah]()

        for (surahInfo, surahName) in zip(surahInfoJson, surahNammeTranslationJson) {
            let translation = Translation(lang: .en, translation: surahName.value.translation)
            let transliteration = Transliteration(lang: .en, transliteration: surahName.value.name)

//            let ayat = Array(ayahList[surahInfo.value.start ... surahInfo.value.end])
            let surah =
                Surah(
                    ayahCount: surahInfo.value.nAyah,
                    firstAyahNo: surahInfo.value.start,
                    lastAyahNo: surahInfo.value.end,
                    name: surahInfo.value.name,
                    nameTranslations: [translation],
                    nameTransliterations: [transliteration],
                    revelationOrder: surahInfo.value.revelationOrder,
                    revelaitonPlace: Surah.RevelationPlace(rawValue: surahInfo.value.type)!,
                    ayat: ayahList)

            surahList.append(surah)
        }

        let quran = Quran(surah: surahList)
        return quran
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
            let res = try JSONDecoder().decode(TranslationJson.self, from: data)
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
