//
//  TextView.swift
//  HTMLTextAttributes
//
//  Created by newone on 26/5/22.
//

import SwiftUI
import UIKit

struct SelectedString {
    var range: Range<String.Index>
    var text: String
}

class CustomUITextView: UITextView {
    func addCustomMenu() {
        let highlightMenuItem = UIMenuItem(title: "Highlight", action: #selector(hightlight(_:)))
        let noteMenuItem = UIMenuItem(title: "Note", action: #selector(note(_:)))
        UIMenuController.shared.menuItems = [highlightMenuItem, noteMenuItem]
    }

    @objc func hightlight(_ sender: Any?) {
        let range = Range(selectedRange, in: text)!
        let selectedString = SelectedString(range: range, text: String(text[range]))
        print(selectedString)
    }

    @objc func note(_ sender: Any?) {
        let range = Range(selectedRange, in: text)!
        let selectedString = SelectedString(range: range, text: String(text[range]))
        print(selectedString)
    }

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
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
            action == #selector(note(_:)) ||
            action == #selector(hightlight(_:)) ||
            action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.select(_:)) ||
            action == Selector(("_lookup:"))
        {
            return true
        }

        return true
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: NSMutableAttributedString
    func makeUIView(context: Context) -> CustomUITextView {
        let textview = CustomUITextView()
        textview.addCustomMenu()
        return textview
    }

    func updateUIView(_ uiView: CustomUITextView, context: Context) {
        uiView.attributedText = text
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(text: .constant(NSMutableAttributedString(string: "Test")))
    }
}
