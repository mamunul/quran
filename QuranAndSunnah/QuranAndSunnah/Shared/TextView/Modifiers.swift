import SwiftUI

enum CustomTextAlignment {
    case justify
    case left
    case right
    case none
}

public extension TextView {
    /// Specifies the alignment of multi-line text
    /// - Parameter alignment: The text alignment
    internal func paragraphStyle(_ alignment: CustomTextAlignment) -> TextView {
        var view = self
        view.paragraphAlignment = alignment
        return view
    }
}
