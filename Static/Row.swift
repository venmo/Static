import UIKit

public typealias Selection = () -> Void

/// Representation of a table row.
public struct Row: Hashable, Equatable {

    // MARK: - Properties

    /// Unique identifier for the row.
    public let UUID: String

    /// The row's primary text.
    public var text: String?

    /// The row's secondary text.
    public var detailText: String?

    /// Accessory for the row.
    public var accessory: Accessory

    /// Action to run when the row is selected.
    public var selection: Selection?

    /// View to be used for the row.
    public var cellClass: CellType.Type

    /// Additional information for the row.
    public var context: [String: AnyObject]?

    var isSelectable: Bool {
        return selection != nil
    }

    var cellIdentifier: String {
        return cellClass.description()
    }

    public var hashValue: Int {
        return UUID.hashValue
    }


    // MARK: - Initiallizers

    public init(text: String? = nil, detailText: String? = nil, selection: Selection? = nil, accessory: Accessory = .None, cellClass: CellType.Type? = nil, context: [String: AnyObject]? = nil, UUID: String = NSUUID().UUIDString) {
        self.UUID = UUID
        self.text = text
        self.detailText = detailText
        self.selection = selection
        self.accessory = accessory
        self.cellClass = cellClass ?? Value1Cell.self
        self.context = context
    }


    // MARK: - Accessory
    public enum Accessory: Equatable {
        case None
        case DisclosureIndicator
        case DetailDisclosureButton(Selection)
        case Checkmark
        case DetailButton(Selection)
        case View(UIView)

        public var type: UITableViewCellAccessoryType {
            switch self {
            case DisclosureIndicator: return .DisclosureIndicator
            case DetailDisclosureButton(_): return .DetailDisclosureButton
            case Checkmark: return .Checkmark
            case DetailButton(_): return .DetailButton
            default: return .None
            }
        }

        public var view: UIView? {
            switch self {
            case View(let view): return view
            default: return nil
            }
        }

        public var selection: Selection? {
            switch self {
            case DetailDisclosureButton(let selection): return selection
            case DetailButton(let selection): return selection
            default: return nil
            }
        }
    }
}

public func ==(lhs: Row, rhs: Row) -> Bool {
    return lhs.UUID == rhs.UUID
}

public func ==(lhs: Row.Accessory, rhs: Row.Accessory) -> Bool {
    switch (lhs, rhs) {
    case (.None, .None): return true
    case (.DisclosureIndicator, .DisclosureIndicator): return true
    case (.DetailDisclosureButton(_), .DetailDisclosureButton(_)): return true
    case (.Checkmark, .Checkmark): return true
    case (.DetailButton(_), .DetailButton(_)): return true
    case (.View(let l), .View(let r)): return l == r
    default: return false
    }
}
