//
//  Repository.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 1/6/22.
//

import Foundation

class AppRepository {
}

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
    var English_Grade: Stringcd 
    var Arabic_Grade: String
}

class TafsirRepository {
}

class HadithRepository {
    func test() -> [HadithJson] {
        //

        do {
            let fileUrl = Bundle.main.url(forResource: "Hadith/AbuDaud/Chapter1.json", withExtension: "")!
            let data = try Data(contentsOf: fileUrl)
//            let content = String(data: data, encoding: .utf8)
            let res = try JSONDecoder().decode([HadithJson].self, from: data)
            return res
        } catch {
            print(error)
        }
        return []
    }
}
