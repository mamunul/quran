import SwiftUI

extension Dictionary {
    static func += (lhs: inout Dictionary, rhs: Dictionary) {
        lhs.merge(rhs) { _, new in new }
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: NSMutableAttributedString
    var searchString: Binding<String>?

    var paragraphAlignment: CustomTextAlignment = .none
    var fontSize: Double? = nil
    var highlights: [Highlight]
    var onHighlight: ((_ highlightedRange: ClosedRange<Int>) -> Void)?
    var onUnhighlight: ((_ highlight: Highlight) -> Void)?

    @Environment(\.colorScheme) var colorScheme

    func makeUIView(context: Context) -> CustomUITextView {
        let textView = CustomUITextView()
        textView.addCustomMenu()
        textView.backgroundColor = .clear
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.onHighlight = onHighlight
        textView.onUnhighlight = onUnhighlight
        return textView
    }

    func updateUIView(_ view: CustomUITextView, context: Context) {
        addTextAttributes()
       
        view.attributedText = text
        view.setHighlights(highlights)
        view.isEditable = false
        view.isEditable = false
        view.isScrollEnabled = false
        if fontSize != nil {
            view.font = UIFont.systemFont(ofSize: CGFloat(fontSize!))
        }

        searchTexts(view)
        view.setNeedsDisplay()
    }

    private func addTextAttributes() {
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
            paragraphStyle.lineSpacing = 10
            paragraphStyle.alignment = .right
            let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            attribute1 += attribute2
        case .none:
            paragraphStyle.alignment = .natural
        }

        let fullRange = NSRange(location: 0, length: text.length)

        text.addAttributes(attribute1, range: fullRange)
    }

    private func searchTexts(_ view: CustomUITextView) {
        if let searchString = searchString?.wrappedValue {
            let searchRange = NSString(string: text.string).range(of: searchString, options: .caseInsensitive)
            view.selectedRange = searchRange // optional
            let attributes = [NSAttributedString.Key.backgroundColor: UIColor.lightGray]
            view.textStorage.addAttributes(attributes, range: searchRange)
            if searchRange.length != 0 {
                view.scrollRangeToVisible(searchRange)
            }
        }
    }
}
