//
//  TextViewFrameCalculator.swift
//  QuranAndSunnah
//
//  Created by newone on 26/6/22.
//

import Foundation
import UIKit

class TextViewFrameCalculator {
    let textView = CustomUITextView()
    func frameSize(for text: String, fontSize: Int, width: CGFloat, paragraphAlignment: CustomTextAlignment) -> CGSize {
        let attributedText = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attributedText.length)
        var attribute: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize))]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        switch paragraphAlignment {
        case .justify:
            paragraphStyle.alignment = .justified
            let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            attribute += attribute2
        case .left:
            paragraphStyle.alignment = .left
            let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            attribute += attribute2
        case .right:
            paragraphStyle.alignment = .right
            let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            attribute += attribute2
        case .none:
            paragraphStyle.alignment = .natural
        }

        let attribute3: [NSAttributedString.Key: Any] = [NSAttributedString.Key.kern: 0]
        attribute += attribute3

        attributedText.addAttributes(attribute, range: fullRange)
        textView.frame.size.width = width

        textView.attributedText = attributedText

        let rect = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: .greatestFiniteMagnitude))
        return rect
    }
}
