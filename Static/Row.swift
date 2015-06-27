import UIKit

typealias RowSelection = Void -> Void

struct Row: Hashable, Equatable {
    let UUID: String
    var text: String?
    var detailText: String?
    var accessory: UITableViewCellAccessoryType = .None
    var selection: RowSelection?
    var cellClass: UITableViewCell.Type = Value1Cell.self

    var cellIdentifier: String {
        return cellClass.description()
    }

    var isSelectable: Bool {
        return selection != nil
    }

    var hashValue: Int {
        return UUID.hashValue
    }

    init(UUID: String = NSUUID().UUIDString, text: String? = nil, detailText: String? = nil, accessory: UITableViewCellAccessoryType? = nil, selection: RowSelection? = nil, cellClass: UITableViewCell.Type? = nil) {
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


func ==(lhs: Row, rhs: Row) -> Bool {
    return lhs.UUID == rhs.UUID
}
