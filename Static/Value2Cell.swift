import UIKit

public class Value2Cell: UITableViewCell, Cell {
	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .Value2, reuseIdentifier: reuseIdentifier)
	}

	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
