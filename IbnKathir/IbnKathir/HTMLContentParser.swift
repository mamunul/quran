//
//  HTMLContentParser.swift
//  IbnKathir
//
//  Created by newone on 29/5/22.
//

import Foundation
import SwiftSoup

let baseFilePath = ""

class HTMLContentParser {
    func execute() {
        do {
            var fileName = "htmml.md"
            fileName = "1.html"
            let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "")!
            let html = try! String(contentsOf: fileUrl, encoding: .utf8)
            
//            let html: String = "<div><p>Lorem ipsum.</p>"
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            let body: Element? = doc.body()
            let content = try body?.getElementsByClass("content")
            print(content?.first())
        } catch let Exception.Error(type, message) {
            print(message)
        } catch {
            print("error")
        }
    }
}
