import UIKit
import Static

class CustomTableViewCell: UITableViewCell, CellType {
    private lazy var centeredLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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

    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 80)
    }
}

extension CellType where Self: CustomTableViewCell {
    func configure(row row: Row) {
        centeredLabel.text = row.text
    }
}
