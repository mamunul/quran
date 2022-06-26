//
//  TextView.swift
//  HTMLTextAttributes
//
//  Created by newone on 26/5/22.
//

import SwiftUI
import UIKit

class CustomUITextView: UITextView, NSLayoutManagerDelegate {
    var onHighlight: ((_ highlightedString: ClosedRange<Int>) -> Void)?
    var onUnhighlight: ((_ highlight: Highlight) -> Void)?

    private var highlights = [Highlight]()

    private var unhighlightItem: Highlight?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        addGestureRecognizer(tapGestureRecognizer)
//        layoutManager.delegate = self
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
            unhighlightItem = firstMatch
            let mnuController = UIMenuController.shared
            let lookupMenu = UIMenuItem(title: "Unhighlight", action: #selector(unhighlight))
            mnuController.menuItems = [lookupMenu]

            becomeFirstResponder()
            let rect = CGRect(origin: location, size: CGSize(width: 10, height: 5))
            UIMenuController.shared.showMenu(from: self, rect: rect)
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

    @objc func unhighlight(_ sender: Any?) {
        textStorage.removeAttribute(NSAttributedString.Key.backgroundColor, range: NSRange(unhighlightItem!.range))
        onUnhighlight?(unhighlightItem!)
    }

    func setHighlights(_ highlights: [Highlight]) {
        self.highlights = highlights
        highlights.forEach { highlight in
            let color = getHighlighColor()
            let attributes = [NSAttributedString.Key.backgroundColor: color]
            if attributedText.length < highlight.range.upperBound { return }
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
            action == Selector(("_define:")) ||
            action == #selector(unhighlight(_:))
        {
            return true
        }

        return true
    }

    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        10 // disabled
    }
}
