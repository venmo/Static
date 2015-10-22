import UIKit
import Static

final class CustomTableViewCell: UITableViewCell, CellType {

    // MARK: - Properties

    private lazy var centeredLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    // MARK: - Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .grayColor()

        contentView.addSubview(centeredLabel)

        let views = ["centeredLabel": centeredLabel]
        var constraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("|-[centeredLabel]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[centeredLabel]-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - CellType

    func configure(row row: Row) {
        centeredLabel.text = row.text
    }
}
