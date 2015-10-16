import UIKit
import Static

class CustomTableViewCell: UITableViewCell, CellType {

    @IBOutlet weak var centeredLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CellType where Self: CustomTableViewCell {
    func configure(row row: Row) {
        centeredLabel?.text = row.text
    }
}
