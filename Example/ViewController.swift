import UIKit
import Static

class ViewController: TableViewController {

    // MARK: - Initializers

    convenience init() {
        self.init(style: .Grouped)
    }


    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Static"

        dataSource.sections = [
            Section(header: "Styles", rows: [
                Row(text: "Value 1", detailText: "Detail", cellClass: Value1Cell.self),
                Row(text: "Value 2", detailText: "Detail", cellClass: Value2Cell.self),
                Row(text: "Subtitle", detailText: "Detail", cellClass: SubtitleCell.self),
                Row(text: "Button", detailText: "Detail", cellClass: ButtonCell.self)
            ])
        ]
    }
}
