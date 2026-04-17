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
    private var highlightMenuItem: UIEditMenuInteraction?

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
        unhighlightItem = firstMatch
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
        highlightMenuItem = UIEditMenuInteraction(delegate: self)
        addInteraction(highlightMenuItem!)
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

    @objc func highlight(_ sender: Any?) {
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
}

extension CustomUITextView: UIEditMenuInteractionDelegate {
    override func editMenu(for textRange: UITextRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let highlightAction = UIAction(title: "Highlight") { [weak self] _ in
            self?.highlight(nil)
        }

        let noteAction = UIAction(title: "Note") { [weak self] _ in
            self?.note(nil)
        }

        let unhighlight = UIAction(title: "Unhighlight") { [weak self] _ in
            self?.unhighlight(nil)
        }

        if unhighlightItem != nil {
            return UIMenu(children: [unhighlight] + suggestedActions)
        } else {
            return UIMenu(children: [highlightAction, noteAction] + suggestedActions)
        }
    }
}
