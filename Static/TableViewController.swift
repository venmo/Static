import UIKit

/// Table view controller with a `DataSource` setup to use its `tableView`. The view controller's
/// `UITableViewDataSource` and `UITableViewDelegate` methods will not be called.
public class TableViewController: UITableViewController {

    // MARK: - Properties

    /// Table view data source.
    public var dataSource = DataSource() {
        willSet {
            dataSource.tableView = nil
        }

        didSet {
            dataSource.tableView = tableView
        }
    }


    // MARK: - UIViewController

    public override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.tableView = tableView
    }
}
