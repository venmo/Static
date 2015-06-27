import UIKit

public class SubtitleCell: UITableViewCell {
	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
	}

	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
