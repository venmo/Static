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


    // MARK: - Initialization

    public override init(style: UITableViewStyle) {
        super.init(style: style)
        initialize()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }


    // MARK: - UIViewController

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        performInitialLoad()
    }


    // MARK: - Private

    private func initialize() {
        dataSource.tableView = tableView
    }

    private var initialLoadOnceToken = dispatch_once_t()
    private func performInitialLoad() {
        dispatch_once(&initialLoadOnceToken) {
            self.tableView.reloadData()
        }
    }
}
