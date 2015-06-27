import UIKit

public typealias RowSelection = Void -> Void

public struct Row: Hashable, Equatable {
    public let UUID: String
    public var text: String?
    public var detailText: String?
    public var accessory: UITableViewCellAccessoryType = .None
    public var selection: RowSelection?
    public var cellClass: UITableViewCell.Type = Value1Cell.self

    public var cellIdentifier: String {
        return cellClass.description()
    }

    public var isSelectable: Bool {
        return selection != nil
    }

    public var hashValue: Int {
        return UUID.hashValue
    }

    public init(UUID: String = NSUUID().UUIDString, text: String? = nil, detailText: String? = nil, accessory: UITableViewCellAccessoryType? = nil, selection: RowSelection? = nil, cellClass: UITableViewCell.Type? = nil) {
        self.UUID = UUID
        self.text = text
        self.detailText = detailText
        self.selection = selection

        if let accessory = accessory {
            self.accessory = accessory
        }

        if let cellClass = cellClass {
            self.cellClass = cellClass
        }
    }
}


public func ==(lhs: Row, rhs: Row) -> Bool {
    return lhs.UUID == rhs.UUID
}
