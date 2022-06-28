//
//  HadithRepository.swift
//  QuranAndSunnah
//
//  Created by newone on 2/6/22.
//

import Foundation

struct HadithJson: Codable {
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

enum HadithContentID: Int, ContentID {
    case bukhari_1
    case muslim_1
    case tirmizi_1
    case abudaud_1
    case ibnmajah_1
    case nasai_1

    func getFilePath() -> String {
        switch self {
        case .bukhari_1:
            return "Hadith/Bukhari/"
        case .muslim_1:
            return "Hadith/Muslim/"
        case .tirmizi_1:
            return "Hadith/Tirmizi/"
        case .abudaud_1:
            return "Hadith/AbuDaud/"
        case .ibnmajah_1:
            return "Hadith/IbnMaja/"
        case .nasai_1:
            return "Hadith/Nesai/"
        }
    }

    func getTitle() -> String {
        switch self {
        case .bukhari_1:
            return "Sahih al-Bukhari"
        case .muslim_1:
            return "Sahih Muslim"
        case .tirmizi_1:
            return "Jami` at-Tirmidhi"
        case .abudaud_1:
            return "Sunan Abi Dawud"
        case .ibnmajah_1:
            return "Sunan Ibn Majah"
        case .nasai_1:
            return "Sunan an-Nasa'i"
        }
    }

    func getLanguage() -> Language {
        return .en
    }

    func getContentType() -> ContentType {
        .translation
    }
}

protocol IHadithDataReadFacade {
    func getAllHadith() async throws -> [HadithText]
    func getCollectorList() -> [HadithCollector]
    func getChapterList(of collector: HadithCollector, language: Language) -> [HadithChapter]
    func getHadithList(of chapter: HadithChapter, collector: HadithCollector, language: Language) throws -> [HadithText]
    func getAllHadith(of collector: HadithCollector) throws -> [HadithText] 
}

class HadithRepository: IHadithDataReadFacade {
    func getChapter(collector: HadithCollector, chapterNo: Int, language: Language) throws -> HadithChapter {
        let fileUrl = Bundle.main.url(forResource: "\(collector.pathComponent)Chapter\(chapterNo).json", withExtension: "")!
        let data = try Data(contentsOf: fileUrl)
        let res = try JSONDecoder().decode([HadithJson].self, from: data)

        var title = ""
        var translations = ""
        var firstItemNo = 0
        var lastItemNo = 0
        if let item = res.first {
            title = item.Chapter_Arabic
            translations = item.Chapter_English
            firstItemNo = (item.Hadith_number as NSString).integerValue
        }

        if let item = res.last {
            lastItemNo = (item.Hadith_number as NSString).integerValue
        }
        var contentId = collector.contentId
        contentId.lang = language
        let chapter = HadithChapter(
            id: chapterNo,
            title: language == .ar ? title : translations,
            chapterNo: chapterNo,
            hadithNo: firstItemNo ... lastItemNo,
            contentId: contentId
        )

        return chapter
    }

    func getChapterList(of collector: HadithCollector, language: Language) -> [HadithChapter] {
        let chapterList = collector.chapterRange.compactMap { chapterNo in
            try? getChapter(collector: collector, chapterNo: chapterNo, language: language)
        }

        return chapterList
    }

    func getAllHadith(of collector: HadithCollector) throws -> [HadithText] {
 
        var collectorHadith = [HadithText]()
        try collector.chapterRange.forEach { chapterNo in
            let list = try self.getHadithList(of: chapterNo, collector: collector, language: .en)
//                        allHadith.append(contentsOf: list)
            collectorHadith.append(contentsOf: list)
        }
        return collectorHadith
    }

    func getAllHadith() async throws -> [HadithText] {
        return try await withThrowingTaskGroup(of: [HadithText].self) { group in

            let collectors = getCollectorList()
            var allHadith = [HadithText]()
            collectors.forEach { collector in
                group.addTask {
                    var collectorHadith = [HadithText]()
                    try collector.chapterRange.forEach { chapterNo in
                        let list = try self.getHadithList(of: chapterNo, collector: collector, language: .en)
//                        allHadith.append(contentsOf: list)
                        collectorHadith.append(contentsOf: list)
                    }
                    return collectorHadith
                }
            }

            for try await list in group {
                allHadith.append(contentsOf: list)
            }

            return allHadith
        }
    }

    private func getHadithList(of chapterNo: Int, collector: HadithCollector, language: Language) throws -> [HadithText] {
        let fileUrl = Bundle.main.url(forResource: "\(collector.pathComponent)Chapter\(chapterNo).json", withExtension: "")!
        let data = try Data(contentsOf: fileUrl)
        let res = try JSONDecoder().decode([HadithJson].self, from: data)

        var contentId = collector.contentId
        contentId.lang = language

        let hadithList = res.map {
            HadithText(
                chapterNo: ($0.Chapter_Number as NSString).integerValue,
                sectionNo: ($0.Section_Number as NSString).integerValue,
                section: language == .ar ? $0.Section_Arabic : $0.Section_English,
                hadithNo: ($0.Hadith_number as NSString).integerValue,
                isnad: language == .ar ? $0.Arabic_Isnad : $0.English_Isnad,
                matn: language == .ar ? $0.Arabic_Matn : $0.English_Matn,
                comment: language == .ar ? $0.Arabic_Comment : $0.Arabic_Comment,
                grade: language == .ar ? $0.Arabic_Grade : $0.English_Grade,
                contentId: contentId
            )
        }
        return hadithList
    }

    func getHadithList(of chapter: HadithChapter, collector: HadithCollector, language: Language) throws -> [HadithText] {
        let hadithList = try getHadithList(of: chapter.chapterNo, collector: collector, language: language)
        return hadithList
    }

    func getCollectorList() -> [HadithCollector] {
        let bukhari = HadithCollector(
            name: "Bukhari",
            id: 1,
            pathComponent: "Hadith/Bukhari/",
            chapterRange: 1 ..< 97,
            contentId: ContentIdentity(contentId: .bukhari_1,
                                       lang: .en,
                                       contentType: .translation)
        )
        let muslim = HadithCollector(
            name: "Muslim",
            id: 2,

            pathComponent: "Hadith/Muslim/",
            chapterRange: 0 ..< 56,
            contentId: ContentIdentity(contentId: .muslim_1,
                                       lang: .en,
                                       contentType: .translation)
        )
        let tirmizi = HadithCollector(
            name: "Tirmizi",
            id: 3,

            pathComponent: "Hadith/Tirmizi/",
            chapterRange: 1 ..< 49,
            contentId: ContentIdentity(contentId: .tirmizi_1,
                                       lang: .en,
                                       contentType: .translation)
        )
        let abuDaud = HadithCollector(
            name: "AbuDaud",
            id: 4,

            pathComponent: "Hadith/AbuDaud/",
            chapterRange: 1 ..< 43,
            contentId: ContentIdentity(contentId: .abudaud_1,
                                       lang: .en,
                                       contentType: .translation)
        )
        let ibnMajah = HadithCollector(
            name: "IbnMajah",
            id: 5,

            pathComponent: "Hadith/IbnMaja/",
            chapterRange: 0 ..< 37,
            contentId: ContentIdentity(contentId: .ibnmajah_1,
                                       lang: .en,
                                       contentType: .translation)
        )
        let nasai = HadithCollector(
            name: "Nasai",
            id: 6,

            pathComponent: "Hadith/Nesai/",
            chapterRange: 1 ..< 51,
            contentId: ContentIdentity(contentId: .nasai_1,
                                       lang: .en,
                                       contentType: .translation)
        )

        var collectors = [HadithCollector]()
        collectors.append(bukhari)
        collectors.append(muslim)
        collectors.append(tirmizi)
        collectors.append(abuDaud)
        collectors.append(ibnMajah)
        collectors.append(nasai)

        return collectors
    }
}
