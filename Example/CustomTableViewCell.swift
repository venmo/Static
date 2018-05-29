import UIKit
import Static

final class CustomTableViewCell: UITableViewCell, Cell {

    // MARK: - Properties

    private lazy var centeredLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    // MARK: - Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .gray

        contentView.addSubview(centeredLabel)

        let views = ["centeredLabel": centeredLabel]
        var constraints: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "|-[centeredLabel]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[centeredLabel]-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - CellType

    func configure(row: Row) {
        centeredLabel.text = row.text
    }
}
