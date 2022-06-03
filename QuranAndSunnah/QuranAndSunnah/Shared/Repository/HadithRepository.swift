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

class HadithRepository {
    func getCollectorList() -> [HadithCollector] {
        let bukhari = HadithCollector(name: "Bukhari", id: 1, pathComponent: "Hadith/Bukhari/", chapterRange: 1 ..< 97)
        let muslim = HadithCollector(name: "Muslim", id: 2, pathComponent: "Hadith/Muslim/", chapterRange: 0 ..< 56)
        let tirmizi = HadithCollector(name: "Tirmizi", id: 3, pathComponent: "Hadith/Tirmizi/", chapterRange: 1 ..< 49)
        let abuDaud = HadithCollector(name: "AbuDaud", id: 4, pathComponent: "Hadith/AbuDaud/", chapterRange: 1 ..< 43)
        let ibnMajah = HadithCollector(name: "IbnMajah", id: 5, pathComponent: "Hadith/IbnMaja/", chapterRange: 0 ..< 37)
        let nasai = HadithCollector(name: "Nasai", id: 6, pathComponent: "Hadith/Nesai/", chapterRange: 1 ..< 51)

        var collectors = [HadithCollector]()
        collectors.append(bukhari)
        collectors.append(muslim)
        collectors.append(tirmizi)
        collectors.append(abuDaud)
        collectors.append(ibnMajah)
        collectors.append(nasai)

        return collectors
    }

    func getChapter(res: [HadithJson],chapterNo:Int) -> HadithChapter {
        let hadithList = res.map {
            Hadith(
                id: $0.Hadith_number,
                chapterNo: Int(Float($0.Chapter_Number)!),
                sectionNo: $0.Section_Number,
                sectionTranslations: [
                    Translation(lang: .en, translation: $0.Chapter_English),
                ],
                section: $0.Chapter_Arabic,
                hadithNo: $0.Hadith_number,
                hadithTranslations: [
                    Translation(lang: .en, translation: $0.English_Hadith),
                ],
                isnadTranslations: [
                    Translation(lang: .en, translation: $0.English_Isnad),
                ],
                matnTranslations: [
                    Translation(lang: .en, translation: $0.English_Matn),
                ],
                hadith: $0.Arabic_Hadith,
                isnad: $0.Arabic_Isnad,
                matn: $0.Arabic_Matn,
                comment: $0.Arabic_Comment,
                gradeTranslations: [
                    Translation(lang: .en, translation: $0.English_Grade),
                ],
                grade: $0.Arabic_Grade,
                bookmark: false,
                tags: [])
        }

//        let chapterNo = 1
        let chapter = HadithChapter(
            id: chapterNo,
            chapterNo: chapterNo,
            title: hadithList.first?.section ?? " ",
            titleTranslations: hadithList.first?.sectionTranslations ?? [],
            hadithList: hadithList
        )

        return chapter
    }

    func getHadith(of collector: HadithCollector) -> HadithBook {
        var hadithChapterList = [HadithChapter]()
        for chapterNo in collector.chapterRange {
            do {
                let fileUrl = Bundle.main.url(forResource: "\(collector.pathComponent)Chapter\(chapterNo).json", withExtension: "")!
                let data = try Data(contentsOf: fileUrl)
                let res = try JSONDecoder().decode([HadithJson].self, from: data)
                let chapter = getChapter(res: res,chapterNo: chapterNo)
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
