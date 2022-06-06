import SwiftUI

/// A SwiftUI TextView implementation that supports both scrolling and auto-sizing layouts
public struct TextView: View {
    @Environment(\.layoutDirection) private var layoutDirection

    @Binding private var text: NSMutableAttributedString
    private var searchString: Binding<String>?
    @State private var calculatedHeight: CGFloat = 44

    var paragraphAlignment: CustomTextAlignment = .none

    /// Makes a new TextView with the specified configuration
    /// - Parameters:
    ///   - text: A binding to the text
    public init(_ text: Binding<String>, searchString: Binding<String>? = nil) {
        _text = Binding(
            get: { NSMutableAttributedString(string: text.wrappedValue) },
            set: { text.wrappedValue = $0.string }
        )
        self.searchString = searchString
    }

    /// Makes a new TextView that supports `NSMutableAttributedString`
    /// - Parameters:
    ///   - text: A binding to the attributed text
    public init(_ text: Binding<NSMutableAttributedString>, searchString: Binding<String>? = nil) {
        _text = text
        self.searchString = searchString
    }

    public var body: some View {
        Representable(
            text: $text, searchString: self.searchString,
            calculatedHeight: $calculatedHeight,
            paragraphAlignment: paragraphAlignment
        )
        .frame(
            minHeight: calculatedHeight,
            maxHeight: calculatedHeight
        )
    }
}
