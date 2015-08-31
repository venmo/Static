import UIKit

/// Table view controller with a `DataSource` setup to use its `tableView`.
public class TableViewController: UIViewController {

    // MARK: - Properties

    /// Returns the table view managed by the controller object.
    public let tableView: UITableView

    /// A Boolean value indicating if the controller clears the selection when the table appears.
    ///
    /// The default value of this property is YES. When YES, the table view controller clears the table’s current selection when it receives a viewWillAppear: message. Setting this property to NO preserves the selection.
    public var clearsSelectionOnViewWillAppear: Bool = true

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

    public init(style: UITableViewStyle) {
        tableView = UITableView(frame: .zero, style: style)
        super.init(nibName: nil, bundle: nil)
		dataSource.tableView = tableView
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        tableView = UITableView(frame: .zero, style: .Plain)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		dataSource.tableView = tableView
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init() {
        self.init(style: .Plain)
    }


    // MARK: - UIViewController

    public override func loadView() {
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view = tableView
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        performInitialLoad()
        clearSelectionsIfNecessary()
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }

    public override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }


    // MARK: - Private

    private var initialLoadOnceToken = dispatch_once_t()
    private func performInitialLoad() {
        dispatch_once(&initialLoadOnceToken) {
            self.tableView.reloadData()
        }
    }

    private func clearSelectionsIfNecessary() {
        guard clearsSelectionOnViewWillAppear else { return }
        tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRowAtIndexPath($0, animated: true) }
    }
}
