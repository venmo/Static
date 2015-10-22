import UIKit
import Static

final class NibTableViewCell: UITableViewCell, CellType {

    @IBOutlet weak var centeredLabel: UILabel!
    
    // MARK: - NibCellType

    static func nib() -> UINib? {
        return UINib(nibName: String(self), bundle: nil)
    }

    func configure(row row: Row) {
        centeredLabel.text = row.text
    }
}
