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

        NSLayoutConstraint.activate([
            centeredLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            centeredLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            centeredLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            centeredLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            centeredLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - CellType

    func configure(row: Row) {
        centeredLabel.text = row.text
    }
}
