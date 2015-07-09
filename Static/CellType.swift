import UIKit

public protocol CellType: class {
    static func description() -> String
    func configure(row row: Row)
}


extension CellType where Self: UITableViewCell {
    public func configure(row row: Row) {
        textLabel?.text = row.text
        detailTextLabel?.text = row.detailText
        accessoryType = row.accessory.type
        accessoryView = row.accessory.view
    }
}
