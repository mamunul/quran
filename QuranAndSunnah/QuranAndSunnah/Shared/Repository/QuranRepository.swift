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
    #if os(macOS)
        private let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
    #endif

    private func makeFileUrl<T: ContentID>(_ basePath: String, contentId: T) -> URL {
        let path = contentId.getFilePath()
        #if os(iOS)
            let url = Bundle.main.url(forResource: path, withExtension: "")!
        #else
            let url = homeDirectory.appendingPathComponent("\(basePath)\(path)")
        #endif

        return url
    }

    private func decodeFromUrl<T: Decodable>(_ url: URL) throws -> T {
        let data = try Data(contentsOf: url)
        let res = try JSONDecoder().decode(T.self, from: data)
        return res
    }

    func getQuranData<T: Decodable, C: ContentID>(_ basePath: String, contentId: C) throws -> T {
        let fileUrl = makeFileUrl(basePath, contentId: contentId)
        let result: T = try decodeFromUrl(fileUrl)
        return result
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
