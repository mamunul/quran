//
//  HadithRepository.swift
//  QuranAndSunnah
//
//  Created by newone on 2/6/22.
//

import Foundation

struct HadithJson: Decodable {
    var Chapter_Number: String
    var Chapter_English: String
    var Chapter_Arabic: String
    var Section_Number: String
    var Section_English: String
    var Section_Arabic: String
    var Hadith_number: String
    var English_Hadith: String
    var English_Isnad: String
    var English_Matn: String
    var Arabic_Hadith: String
    var Arabic_Isnad: String
    var Arabic_Matn: String
    var Arabic_Comment: String
    var English_Grade: String
    var Arabic_Grade: String
}

enum HadithContentID: ContentID {
    case bukhari_1
    case muslim_1
    case tirmizi_1
    case abudaud_1
    case ibnmajah_1
    case nasai_1
}

class HadithRepository {
    func getCollectorList() -> [HadithCollector] {
        let bukhari = HadithCollector(name: "Bukhari", id: 1, contentID: .bukhari_1, pathComponent: "Hadith/Bukhari/", chapterRange: 1 ..< 97)
        let muslim = HadithCollector(name: "Muslim", id: 2, contentID: .muslim_1, pathComponent: "Hadith/Muslim/", chapterRange: 0 ..< 56)
        let tirmizi = HadithCollector(name: "Tirmizi", id: 3, contentID: .tirmizi_1, pathComponent: "Hadith/Tirmizi/", chapterRange: 1 ..< 49)
        let abuDaud = HadithCollector(name: "AbuDaud", id: 4, contentID: .abudaud_1, pathComponent: "Hadith/AbuDaud/", chapterRange: 1 ..< 43)
        let ibnMajah = HadithCollector(name: "IbnMajah", id: 5, contentID: .ibnmajah_1, pathComponent: "Hadith/IbnMaja/", chapterRange: 0 ..< 37)
        let nasai = HadithCollector(name: "Nasai", id: 6, contentID: .nasai_1, pathComponent: "Hadith/Nesai/", chapterRange: 1 ..< 51)

        var collectors = [HadithCollector]()
        collectors.append(bukhari)
        collectors.append(muslim)
        collectors.append(tirmizi)
        collectors.append(abuDaud)
        collectors.append(ibnMajah)
        collectors.append(nasai)

        return collectors
    }

    func getHadithList(of chapter: HadithChapter, collector: HadithCollector) throws -> [Hadith] {
        let fileUrl = Bundle.main.url(forResource: "\(collector.pathComponent)Chapter\(chapter.chapterNo).json", withExtension: "")!
        let data = try Data(contentsOf: fileUrl)
        let res = try JSONDecoder().decode([HadithJson].self, from: data)

        let hadithList = res.map {
            Hadith(
                id: $0.Hadith_number,
                chapterNo: Int(Float($0.Chapter_Number)!),
                sectionNo: $0.Section_Number,
                sectionTranslations: [
                    TextContent(contentID: collector.contentID, lang: .en, text: $0.Chapter_English),
                ],
                section: $0.Chapter_Arabic,
                hadithNo: $0.Hadith_number,
                hadithTranslations: [
                    TextContent(contentID: collector.contentID, lang: .en, text: $0.English_Hadith),
                ],
                isnadTranslations: [
                    TextContent(contentID: collector.contentID, lang: .en, text: $0.English_Isnad),
                ],
                matnTranslations: [
                    TextContent(contentID: collector.contentID, lang: .en, text: $0.English_Matn),
                ],
                hadith: $0.Arabic_Hadith,
                isnad: $0.Arabic_Isnad,
                matn: $0.Arabic_Matn,
                comment: $0.Arabic_Comment,
                gradeTranslations: [
                    TextContent(contentID: collector.contentID, lang: .en, text: $0.English_Grade),
                ],
                grade: $0.Arabic_Grade,
                bookmark: false,
                tags: [])
        }
        return hadithList
    }

    func getChapter(collector: HadithCollector, chapterNo: Int, contentID: HadithContentID) throws -> HadithChapter {
        let fileUrl = Bundle.main.url(forResource: "\(collector.pathComponent)Chapter\(chapterNo).json", withExtension: "")!
        let data = try Data(contentsOf: fileUrl)
        let res = try JSONDecoder().decode([HadithJson].self, from: data)

        var title = ""
        var translations = [TextContent]()
        var firstItemNo = 0
        var lastItemNo = 0
        if let item = res.first {
            title = item.Chapter_Arabic
            translations = [TextContent(contentID: collector.contentID, lang: .en, text: item.Chapter_English)]
            firstItemNo = (item.Hadith_number as NSString).integerValue
        }

        if let item = res.last {
            lastItemNo = (item.Hadith_number as NSString).integerValue
        }

        let chapter = HadithChapter(
            id: chapterNo,
            chapterNo: chapterNo,
            title: title,
            titleTranslations: translations,
            hadithNo: firstItemNo ... lastItemNo
        )

        return chapter
    }

    func getHadith(of collector: HadithCollector) throws -> HadithBook {
        var hadithChapterList = [HadithChapter]()
        for chapterNo in collector.chapterRange {
            do {
                let chapter = try getChapter(collector: collector, chapterNo: chapterNo, contentID: collector.contentID)
                hadithChapterList.append(chapter)
            } catch {
                print(error)
            }
        }

        let hadithBook =
            HadithBook(
                name: collector.name,
                nameTranslations: [],
                numberOfHadith: 10,
                type: collector,
                chapters: hadithChapterList
            )
        return hadithBook
    }
}
