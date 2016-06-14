import UIKit
import Static

final class NibTableViewCell: UITableViewCell, Cell {

    // MARK: - Properties

    @IBOutlet weak private var centeredLabel: UILabel!

    
    // MARK: - CellType

    static func nib() -> UINib? {
        return UINib(nibName: String(self), bundle: nil)
    }

    func configure(row: Row) {
        centeredLabel.text = row.text
    }
}
