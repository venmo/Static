import UIKit

public protocol Cell: AnyObject {
    static func description() -> String
    func setRow(row: Row?)
}


extension Cell where Self: UITableViewCell {
    public func setRow(row: Row?) {
        textLabel?.text = row?.text
        detailTextLabel?.text = row?.detailText
        accessoryType = row?.accessory ?? .None
    }
}
