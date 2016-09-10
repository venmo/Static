import UIKit

open class ButtonCell: UITableViewCell, CellType {

    // MARK: - Initializers

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }


    // MARK: - UIView

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        textLabel?.textColor = tintColor
    }


    // MARK: - Private

    fileprivate func initialize() {
        tintColorDidChange()
    }
}
