import UIKit

public class TableViewController: UITableViewController {

    // MARK: - Properties

    public var dataSource = TableDataSource()


    // MARK: - UIViewController

    public override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.tableView = tableView
    }
}
