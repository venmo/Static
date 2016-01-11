import UIKit

/// Table view controller with a `DataSource` setup to use its `tableView`.
public class TableViewController: UIViewController {

    // MARK: - Properties

    /// Returns the table view managed by the controller object.
    public let tableView: UITableView

    /// A Boolean value indicating if the controller clears the selection when the table appears.
    ///
    /// The default value of this property is true. When true, the table view controller clears the table’s current selection when it receives a viewWillAppear: message. Setting this property to false preserves the selection.
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
        clearSelectionsIfNecessary(animated)
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

    private func clearSelectionsIfNecessary(animated: Bool) {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows where clearsSelectionOnViewWillAppear else { return }
        guard let coordinator = transitionCoordinator() else {
            deselectRowsAtIndexPaths(selectedIndexPaths, animated: animated)
            return
        }

        let animation: UIViewControllerTransitionCoordinatorContext -> Void = { [weak self] _ in
            self?.deselectRowsAtIndexPaths(selectedIndexPaths, animated: animated)
        }

        let completion: UIViewControllerTransitionCoordinatorContext -> Void = { [weak self] context in
            if context.isCancelled() {
                self?.selectRowsAtIndexPaths(selectedIndexPaths, animated: animated)
            }
        }

        coordinator.animateAlongsideTransition(animation, completion: completion)
    }

    private func selectRowsAtIndexPaths(indexPaths: [NSIndexPath], animated: Bool) {
        indexPaths.forEach { tableView.selectRowAtIndexPath($0, animated: animated, scrollPosition: .None) }
    }

    private func deselectRowsAtIndexPaths(indexPaths: [NSIndexPath], animated: Bool) {
        indexPaths.forEach { tableView.deselectRowAtIndexPath($0, animated: animated) }
    }
}
