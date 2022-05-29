//
//  main.swift
//  Test
//
//  Created by newone on 29/5/22.
//

import Foundation
import SwiftSoup

print("Hello, World!")

do {
    let html: String = "<div><p>Lorem ipsum.</p>"
    let doc: Document = try SwiftSoup.parseBodyFragment(html)
    let body: Element? = doc.body()
    print(body)
} catch let Exception.Error(type, message) {
    print(message)
} catch {
    print("error")
}
