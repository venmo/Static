import UIKit

/// Representation of a table row.
public struct Row: Hashable, Equatable {

    // MARK: - Types

    public typealias Selection = () -> Void


    // MARK: - Properties

    /// Unique identifier for the row.
    public let UUID: String

    /// The row's primary text.
    public var text: String?

    /// The rows secondary text.
    public var detailText: String?

    /// Accessory for the row.
    public var accessoryType: UITableViewCellAccessoryType
    public var accessoryView: UIView?

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

    public init(text: String? = nil, detailText: String? = nil, accessoryType: UITableViewCellAccessoryType? = nil, accessoryView: UIView? = nil, selection: Selection? = nil, cellClass: CellType.Type? = nil, context: [String: AnyObject]? = nil, UUID: String = NSUUID().UUIDString) {
        self.UUID = UUID
        self.text = text
        self.detailText = detailText
        self.selection = selection
        self.accessoryType = accessoryType ?? .None
        self.accessoryView = accessoryView
        self.cellClass = cellClass ?? Value1Cell.self
        self.context = context
    }
}


public func ==(lhs: Row, rhs: Row) -> Bool {
    return lhs.UUID == rhs.UUID
}
