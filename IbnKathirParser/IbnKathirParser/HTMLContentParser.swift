//
//  HTMLContentParser.swift
//  IbnKathir
//
//  Created by newone on 29/5/22.
//

import Foundation
import SwiftSoup

class HTMLContentParser {
    func parseConntent(fileUrl: URL) -> String {
        do {
            let html = try! String(contentsOf: fileUrl, encoding: .utf8)
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            let body: Element? = doc.body()
            guard let content = try body?.getElementsByClass("content") else {
                return ""
            }
            let str = try content.toString()
            return str
        } catch {
            print(error)
        }

        return ""
    }

    func saveString(content: String, path: URL) throws {
        try content.write(toFile: path.path, atomically: true, encoding: .utf8)
    }

    func traverseFiles(pathUrl: URL) {
        let fileManager = FileManager.default

        do {
            for folder in try fileManager.contentsOfDirectory(atPath: pathUrl.path) {
                let path = pathUrl.appendingPathComponent(folder)
                let isDirectory = try path.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false
                let isHidden = try path.resourceValues(forKeys: [.isHiddenKey]).isHidden ?? false
                if isHidden { continue }
                if isDirectory {
                    traverseFiles(pathUrl: path)
                } else {
//                    print(path)
                    do {
                        let content = parseConntent(fileUrl: path)
//                    print(content)

                        try saveString(content: content, path: path)
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
    }

    func execute(url: URL) {
        #if os(iOS)
            let directory = Bundle.main.bundleURL.appendingPathComponent("IbnKathirContents", isDirectory: true)
        #else
            let directory = url
        #endif
        print(directory)
        traverseFiles(pathUrl: directory)
    }
}
