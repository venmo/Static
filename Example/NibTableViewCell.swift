import UIKit
import Static

final class NibTableViewCell: UITableViewCell, CellType {

    // MARK: - Properties

    @IBOutlet weak fileprivate var centeredLabel: UILabel!

    
    // MARK: - CellType

    static func nib() -> UINib? {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    func configure(row: Row) {
        centeredLabel.text = row.text
    }
}
