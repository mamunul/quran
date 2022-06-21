//
//  FileHandler.swift
//  QuranAndSunnah
//
//  Created by newone on 20/6/22.
//

import Foundation

class FileHandler {
    enum FileError: Error {
        case invalidPath
    }

    private let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    private func createFileIfNotExists(_ url: URL) throws {
        let pathWithoutFileExtension = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(atPath: pathWithoutFileExtension.path, withIntermediateDirectories: true)
    }

    func save<T: Encodable>(model: T, relativePath: String) throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let encodeableObjectJson = try encoder.encode(model)
        guard let fileUrl = baseUrl?.appendingPathComponent(relativePath) else { throw FileError.invalidPath }
        try createFileIfNotExists(fileUrl)
        try encodeableObjectJson.write(to: fileUrl)
    }

    func read<T: Decodable>(relativePath: String) throws -> T{
        guard let fileUrl = baseUrl?.appendingPathComponent(relativePath) else { throw FileError.invalidPath }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = try Data(contentsOf: fileUrl)
        let res = try decoder.decode(T.self, from: data)
        return res
    }
}
