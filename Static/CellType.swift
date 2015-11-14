import UIKit

public protocol CellType: class {
    static func description() -> String
    static func nib() -> UINib?

    func configure(row row: Row)
}

extension CellType {
    public static func nib() -> UINib? {
        return nil
    }
}

extension CellType where Self: UITableViewCell {
    public func configure(row row: Row) {
        textLabel?.text = row.text
        detailTextLabel?.text = row.detailText
        imageView?.image = row.image
        accessoryType = row.accessory.type
        accessoryView = row.accessory.view
    }
}
