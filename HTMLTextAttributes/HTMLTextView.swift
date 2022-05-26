//
//  HTMLTextView.swift
//  Sample
//
//  Created by newone on 26/5/22.
//

import SwiftUI

struct HTMLTextView: View {
    @State var attributedString = AttributedString("Wait...Loading...")
    var body: some View {
        ScrollView {
            Text("«هِيَ أُمُّ الْقُرْآنِ وَهِيَ السَّبْعُ الْمَثَانِي وَهِيَ الْقُرْآنُ الْعَظِيمُ»")
                .font(Font(UIFont(name: "_PDMS_Saleem_QuranFont", size: UIFont.labelFontSize)!))
            Text("Sample Text Sample Text Sample Text")
                .padding()
                .font(Font(UIFont(name: "CassandraPersonalUse-Regular", size: UIFont.labelFontSize)!))            .textSelection(.enabled)

            Text(attributedString)
                .background(Color.yellow)
                .textSelection(.enabled)
                .onAppear {
                    let fileUrl = Bundle.main.url(forResource: "html.md", withExtension: "")!
                    let data = try! Data(contentsOf: fileUrl)
                    let options: [NSAttributedString.DocumentReadingOptionKey: Any] =
                        [
                            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                            NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue),
                        ]
                    checkInAppFonts()
                    if let nsAttributedString =
                        try? NSMutableAttributedString(
                            data: data,
                            options: options,
                            documentAttributes: nil
                        ) {
                        
                        checkAttributeFonts(nsAttributedString: nsAttributedString)
                        self.attributedString = AttributedString(nsAttributedString)
                    }
                }
        }
    }

    func checkInAppFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            var scaledFont: UIFont?
            if let customFont = UIFont(name: family, size: UIFont.labelFontSize) {
                scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
            }
            print("Family: \(family)  names: \(names) size:\(scaledFont)")
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

struct HTMLTextView_Previews: PreviewProvider {
    static var previews: some View {
        HTMLTextView()
    }
}
