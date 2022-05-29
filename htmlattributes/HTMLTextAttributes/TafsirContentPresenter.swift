//
//  TafsirContentPresenter.swift
//  HTMLTextAttributes
//
//  Created by newone on 29/5/22.
//

import Foundation
import UIKit

class TafsirContentPresenter: ObservableObject {
    @Published var attributedContent = NSMutableAttributedString(string: "")

    func scaleContent(scaleState: Double) {
        print(scaleState)
    }

    func onViewAppear() -> NSMutableAttributedString {
        var fileName = "htmml.md"
        fileName = "0.html"
        let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "")!
        let data = try! Data(contentsOf: fileUrl)
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] =
            [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue),
            ]
        if let nsAttributedString =
            try? NSMutableAttributedString(
                data: data,
                options: options,
                documentAttributes: nil
            ) {
            return nsAttributedString
        }
        return NSMutableAttributedString(string: "")
    }

    func checkInAppFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            var scaledFont: UIFont?
            if let customFont = UIFont(name: family, size: UIFont.labelFontSize) {
                scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
            }
            print("Family: \(family)  names: \(names) size:\(String(describing: scaledFont))")
        }
    }

    func addAttributeFonts(nsAttributedString: NSMutableAttributedString) {
        nsAttributedString.beginEditing()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "_PDMS_Saleem_QuranFont", size: UIFont.labelFontSize)!]
        nsAttributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: nsAttributedString.length)) { _, _, _ in
            nsAttributedString.removeAttribute(.font, range: NSRange(location: 0, length: nsAttributedString.length))
            nsAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: nsAttributedString.length))
        }
        nsAttributedString.endEditing()
    }

    func checkAttributeFonts(nsAttributedString: NSMutableAttributedString) {
        nsAttributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: nsAttributedString.length)) { value, _, _ in
            print((value as! UIFont).fontName)
        }
    }

    func searchAndHighlight(content: String, searchString: String, mutableAttributeString: NSMutableAttributedString) -> NSMutableAttributedString {
        let range = NSString(string: content).range(of: searchString, options: .caseInsensitive) // 2
        let highlightColor = UIColor.systemYellow
        let highlightedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.backgroundColor: highlightColor] // 4

        mutableAttributeString.addAttributes(highlightedAttributes, range: range) // 5

        return mutableAttributeString
    }
}
