//
//  TextView.swift
//  HTMLTextAttributes
//
//  Created by newone on 26/5/22.
//

import SwiftUI
import UIKit

class CITextView: UITextView {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if
            action == #selector(copy(_:)) ||
            action == #selector(select(_:)) ||
            action == #selector(selectAll(_:))
        {
            return true
        } else {
            return false
        }
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: NSMutableAttributedString

    func makeUIView(context: Context) -> CITextView {
        CITextView()
    }

    func updateUIView(_ uiView: CITextView, context: Context) {
        uiView.attributedText = text
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(text: .constant(NSMutableAttributedString(string: "Test")))
    }
}
