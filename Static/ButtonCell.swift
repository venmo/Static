import UIKit

public class ButtonCell: UITableViewCell, Cell {

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

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        textLabel?.textColor = tintColor
    }


    // MARK: - Private

    private func initialize() {
        tintColorDidChange()
    }
}
