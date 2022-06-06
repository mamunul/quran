import SwiftUI

extension Dictionary {
    static func += (lhs: inout Dictionary, rhs: Dictionary) {
        lhs.merge(rhs) { _, new in new }
    }
}

extension TextView {
    struct Representable: UIViewRepresentable {
        @Binding var text: NSMutableAttributedString
        var searchString: Binding<String>?
        @Binding var calculatedHeight: CGFloat

        var paragraphAlignment: CustomTextAlignment = .none

        @Environment(\.colorScheme) var colorScheme

        func makeUIView(context: Context) -> CustomUITextView {
            let textView = CustomUITextView()
            textView.addCustomMenu()
            textView.backgroundColor = .clear
            textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            return textView
        }

        func updateUIView(_ view: CustomUITextView, context: Context) {
            let textColor = colorScheme == .dark ? UIColor.white : UIColor.black
            var attribute1: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: textColor]
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            switch paragraphAlignment {
            case .justify:
                paragraphStyle.alignment = .justified
                let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
                attribute1 += attribute2
            case .left:
                paragraphStyle.alignment = .left
                let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
                attribute1 += attribute2
            case .right:
                paragraphStyle.alignment = .right
                let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
                attribute1 += attribute2
            case .none:
                paragraphStyle.alignment = .natural
            }

            let fullRange = NSRange(location: 0, length: text.length)
            text.addAttributes(attribute1, range: fullRange)

            view.attributedText = text
            view.isEditable = false
            view.isEditable = false
            view.isScrollEnabled = false
            if let searchString = searchString?.wrappedValue {
                let searchRange = NSString(string: text.string).range(of: searchString, options: .caseInsensitive)
                view.selectedRange = searchRange // optional
                let attributes = [NSAttributedString.Key.backgroundColor: UIColor.lightGray]
                view.textStorage.addAttributes(attributes, range: searchRange)
                if searchRange.length != 0 {
                    view.scrollRangeToVisible(searchRange)
                }
            }

            recalculateHeight(view)
            view.setNeedsDisplay()
        }

        private func recalculateHeight(_ view: CustomUITextView) {
            let newSize = view.sizeThatFits(CGSize(width: view.frame.width, height: .greatestFiniteMagnitude))
            guard $calculatedHeight.wrappedValue != newSize.height else { return }

            DispatchQueue.main.async { // call in next render cycle.
                self.$calculatedHeight.wrappedValue = newSize.height
            }
        }
    }
}
