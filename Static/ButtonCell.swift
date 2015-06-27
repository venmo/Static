import UIKit

class ButtonCell: UITableViewCell {

    // MARK: - Initializers

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }


    // MARK: - UIView

    override func tintColorDidChange() {
        super.tintColorDidChange()
        textLabel?.textColor = tintColor
    }


    // MARK: - Private

    private func initialize() {
        tintColorDidChange()
    }
}
