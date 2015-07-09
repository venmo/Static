import UIKit

public struct Row: Hashable, Equatable {

    // MARK: - Types

    public typealias Selection = () -> Void


    // MARK: - Properties

    public let UUID: String
    public var text: String?
    public var detailText: String?
    public var accessoryType: UITableViewCellAccessoryType
    public var accessoryView: UIView?
    public var selection: Selection?
    public var cellClass: CellType.Type
    public var context: [String: AnyObject]?

    public var cellIdentifier: String {
        return cellClass.description()
    }

    public var isSelectable: Bool {
        return selection != nil
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
