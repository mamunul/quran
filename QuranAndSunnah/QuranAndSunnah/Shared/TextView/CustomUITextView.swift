//
//  TextView.swift
//  HTMLTextAttributes
//
//  Created by newone on 26/5/22.
//

import SwiftUI
import UIKit

class CustomUITextView: UITextView {
    override var keyCommands: [UIKeyCommand]? {
        return (super.keyCommands ?? []) + [
            UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(escape(_:)))
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

    @objc func hightlight(_ sender: Any?) {
        var color = UIColor.yellow
        if traitCollection.userInterfaceStyle == .dark {
            color = UIColor.purple
        }
        let attributes = [NSAttributedString.Key.backgroundColor: color]
        textStorage.addAttributes(attributes, range: selectedRange)
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
