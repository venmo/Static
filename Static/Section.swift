import UIKit

/// Representation of a table section.
public struct Section: Hashable, Equatable {

    // MARK: - Types

    /// Representation of a section header or footer.
    public enum Extremity {
        /// System defined style for the title of the header or footer.
        case Title(String)

        /// Custom view for the header or footer. The height will be the view's `bounds.height`.
        case View(UIView)

        public var title: String? {
            switch self {
            case .Title(let extremityTitle): return extremityTitle
            default: return nil
            }
        }

        public var view: UIView? {
            switch self {
            case .View(let extremityView): return extremityView
            default: return nil
            }
        }

        public var viewHeight: CGFloat? {
            return view?.bounds.height
        }
    }


    // MARK: - Properties

    /// Unique identifier used to identify the section.
    public let UUID: String

    /// Title or view for the header of the section.
    public var header: Extremity?

    /// Array of rows for the section.
    public var rows: [Row]

    /// Title or view for the header of the section.
    public var footer: Extremity?

    public var hashValue: Int {
        return UUID.hashValue
    }


    // MARK: - Initiailizers

    public init(header: Extremity? = nil, rows: [Row] = [], footer: Extremity? = nil, UUID: String = NSUUID().UUIDString) {
        self.UUID = UUID
        self.header = header
        self.rows = rows
        self.footer = footer
    }
}


extension Section.Extremity: StringLiteralConvertible {
    public typealias UnicodeScalarLiteralType = StringLiteralType
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType

    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self = .Title(value)
    }

    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self = .Title(value)
    }

    public init(stringLiteral value: StringLiteralType) {
        self = .Title(value)
    }
}


public func ==(lhs: Section, rhs: Section) -> Bool {
    return lhs.UUID == rhs.UUID
}
