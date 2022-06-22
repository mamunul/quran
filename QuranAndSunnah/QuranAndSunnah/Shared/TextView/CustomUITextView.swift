//
//  TextView.swift
//  HTMLTextAttributes
//
//  Created by newone on 26/5/22.
//

import SwiftUI
import UIKit

class CustomUITextView: UITextView {
    var onHighlight: ((_ highlightedString: ClosedRange<Int>) -> Void)?
    var onUnhighlight: ((_ highlight: Highlight) -> Void)?

    private var highlights = [Highlight]()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        let location: CGPoint = gesture.location(in: self)
        let charIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        let firstMatch = highlights.first { highlight in
            highlight.range.contains(charIndex)
        }

        if firstMatch != nil {
            print("matched")
        }
    }

    override var keyCommands: [UIKeyCommand]? {
        return (super.keyCommands ?? []) + [
            UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(escape(_:))),
        ]
    }

    @objc private func escape(_ sender: Any) {
        resignFirstResponder()
    }

    func addCustomMenu() {
        let highlightMenuItem = UIMenuItem(title: "Highlight", action: #selector(hightlight(_:)))
        let noteMenuItem = UIMenuItem(title: "Note", action: #selector(note(_:)))
        UIMenuController.shared.menuItems = [highlightMenuItem, noteMenuItem]
    }

    func unhighlight(_ highlight: Highlight) {
//        let color = getHighlighColor()
//        let attributes = [NSAttributedString.Key.backgroundColor: color]
        textStorage.removeAttribute(NSAttributedString.Key.backgroundColor, range: NSRange(highlight.range))
//        textStorage.addAttributes(attributes, range: selectedRange)
//        onHighLight?(selectedRange.lowerBound ... selectedRange.upperBound - 1)
        onUnhighlight?(highlight)
    }

    func setHighlights(_ highlights: [Highlight]) {
        self.highlights = highlights
        highlights.forEach { highlight in
            let color = getHighlighColor()
            let attributes = [NSAttributedString.Key.backgroundColor: color]
            if attributedText.length < highlight.range.upperBound { return }
//            print(attributedText.size(), highlight.range)
            textStorage.addAttributes(attributes, range: NSRange(highlight.range))
        }
    }

    private func getHighlighColor() -> UIColor {
        var color = UIColor.yellow
        if traitCollection.userInterfaceStyle == .dark {
            color = UIColor.purple
        }
        return color
    }

    @objc func hightlight(_ sender: Any?) {
        let color = getHighlighColor()
        let attributes = [NSAttributedString.Key.backgroundColor: color]
        textStorage.addAttributes(attributes, range: selectedRange)
        onHighlight?(selectedRange.lowerBound ... selectedRange.upperBound - 1)
    }

    @objc func note(_ sender: Any?) {
        var color = UIColor.orange
        if traitCollection.userInterfaceStyle == .dark {
            color = UIColor.blue
        }
        let attributes = [NSAttributedString.Key.backgroundColor: color]
        textStorage.addAttributes(attributes, range: selectedRange)
    }

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
            action == #selector(UIResponderStandardEditActions.select(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
            action == #selector(UIResponderStandardEditActions.paste(_:)) ||
            action == #selector(UIResponderStandardEditActions.delete(_:)) ||
            action == Selector(("_promptForReplace:")) ||
            action == Selector(("_transliterateChinese:")) ||
            action == Selector(("_insertDrawing:")) ||
            action == #selector(captureTextFromCamera(_:)) ||
            action == Selector(("_showTextStyleOptions:")) ||
            action == Selector(("_translate:")) ||
            action == Selector(("_addShortcut:")) ||
            action == Selector(("_accessibilitySpeak:")) ||
            action == Selector(("_accessibilitySpeakLanguageSelection:")) ||
            action == Selector(("_accessibilityPauseSpeaking:")) ||
            action == Selector(("_share:")) ||
            action == #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft(_:)) ||
            action == #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight(_:))
        {
            return false
        } else if
            action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(note(_:)) ||
            action == #selector(hightlight(_:)) ||
            action == Selector(("_lookup:")) ||
            action == Selector(("_define:"))
        {
            return true
        }

        return true
    }
}
