import UIKit

/// Table view data source.
///
/// You should always access this object from the main thread since it talks to UIKit.
open class DataSource: NSObject {

    // MARK: - Properties

    /// The table view that will use this object as its data source.
    open weak var tableView: UITableView? {
        willSet {
            if let tableView = tableView {
                tableView.dataSource = nil
                tableView.delegate = nil
            }

            registeredCellIdentifiers.removeAll()
        }

        didSet {
            assert(Thread.isMainThread, "You must access Static.DataSource from the main thread.")
            updateTableView()
        }
    }

    /// Sections to use in the table view.
    open var sections: [Section] {
        didSet {
            assert(Thread.isMainThread, "You must access Static.DataSource from the main thread.")
            refresh()
        }
    }

    /// Section index titles.
    open var sectionIndexTitles: [String]? {
        didSet {
            assert(Thread.isMainThread, "You must access Static.DataSource from the main thread.")
            tableView?.reloadData()
        }
    }

    /// Automatically deselect rows after they are selected
    open var automaticallyDeselectRows = true

    fileprivate var registeredCellIdentifiers = Set<String>()


    // MARK: - Initializers

    /// Initialize with optional `tableView` and `sections`.
    public init(tableView: UITableView? = nil, sections: [Section]? = nil) {
        assert(Thread.isMainThread, "You must access Static.DataSource from the main thread.")

        self.tableView = tableView
        self.sections = sections ?? []

        super.init()

        updateTableView()
    }

    deinit {
        // nil out the table view to ensure the table view data source and delegate niled out
        tableView = nil
    }


    // MARK: - Public

    open func rowAtPoint(_ point: CGPoint) -> Row? {
        guard let indexPath = tableView?.indexPathForRow(at: point) else { return nil }
        return rowForIndexPath(indexPath)
    }


    // MARK: - Private

    fileprivate func updateTableView() {
        guard let tableView = tableView else { return }
        tableView.dataSource = self
        tableView.delegate = self
        refresh()
    }

    fileprivate func refresh() {
        refreshTableSections()
        refreshRegisteredCells()
    }

    fileprivate func sectionForIndex(_ index: Int) -> Section? {
        if sections.count <= index {
            assert(false, "Invalid section index: \(index)")
            return nil
        }

        return sections[index]
    }

    fileprivate func rowForIndexPath(_ indexPath: IndexPath) -> Row? {
        if let section = sectionForIndex(indexPath.section) {
            let rows = section.rows
            if rows.count >= indexPath.row {
                return rows[indexPath.row]
            }
        }

        assert(false, "Invalid index path: \(indexPath)")
        return nil
    }

    fileprivate func refreshTableSections(_ oldSections: [Section]? = nil) {
        guard let tableView = tableView else { return }
        guard let oldSections = oldSections else {
            tableView.reloadData()
            return
        }

        let oldCount = oldSections.count
        let newCount = sections.count
        let delta = newCount - oldCount
        let animation: UITableViewRowAnimation = .automatic

        tableView.beginUpdates()

        if delta == 0 {
            tableView.reloadSections(IndexSet(integersIn: NSMakeRange(0, newCount).toRange()!), with: animation)
        } else {
            if delta > 0 {
                // Insert sections
                tableView.insertSections(IndexSet(integersIn: NSMakeRange(oldCount - 1, delta).toRange() ?? 0..<0), with: animation)
            } else {
                // Remove sections
                tableView.deleteSections(IndexSet(integersIn: NSMakeRange(oldCount - 1, -delta).toRange() ?? 0..<0), with: animation)
            }

            // Reload existing sections
            let commonCount = min(oldCount, newCount)
            tableView.reloadSections(IndexSet(integersIn: NSMakeRange(0, commonCount).toRange()!), with: animation)
        }

        tableView.endUpdates()
    }

    fileprivate func refreshRegisteredCells() {
        // A table view is required to manipulate registered cells
        guard let tableView = tableView else { return }

        // Filter to only rows with unregistered cells
        let rows = sections.flatMap{ $0.rows }.filter { !self.registeredCellIdentifiers.contains($0.cellIdentifier) }

        for row in rows {
            let identifier = row.cellIdentifier

            // Check again in case there were duplicate new cell classes
            if registeredCellIdentifiers.contains(identifier) {
                continue
            }

            registeredCellIdentifiers.insert(identifier)
            if let nib = row.cellClass.nib() {
                tableView.register(nib, forCellReuseIdentifier: identifier)
            } else {
                tableView.register(row.cellClass, forCellReuseIdentifier: identifier)
            }
        }
    }
}


extension DataSource: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionForIndex(section)?.rows.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let row = rowForIndexPath(indexPath) {
            let tableCell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier, for: indexPath)

            if let cell = tableCell as? CellType {
                cell.configure(row: row)
            }

            return tableCell
        }

        return UITableViewCell()
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionForIndex(section)?.header?.title
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionForIndex(section)?.header?.view
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionForIndex(section)?.header?.viewHeight ?? UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sectionForIndex(section)?.footer?.title
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sectionForIndex(section)?.footer?.view
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionForIndex(section)?.footer?.viewHeight ?? UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return rowForIndexPath(indexPath)?.canEdit ?? false
    }

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return rowForIndexPath(indexPath)?.editActions.map {
            action in
            let rowAction = UITableViewRowAction(style: action.style, title: action.title) { (_, _) in
                action.selection?()
            }

            // These calls have side effects when setting to nil
            // Setting a background color to nil will wipe out any predefined style
            // Wrapping these in if-lets prevents nil-setting side effects
            if let backgroundColor = action.backgroundColor {
                rowAction.backgroundColor = backgroundColor
            }

            if let backgroundEffect = action.backgroundEffect {
                rowAction.backgroundEffect = backgroundEffect
            }

            return rowAction
        }
    }

    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard let sectionIndexTitles = sectionIndexTitles, sectionIndexTitles.count >= sections.count else { return nil }
        return sectionIndexTitles
    }

    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        for (i, section) in sections.enumerated() {
            if let indexTitle = section.indexTitle, indexTitle == title {
                return i
            }
        }
        return max(index, sections.count - 1)
    }
}


extension DataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return rowForIndexPath(indexPath)?.isSelectable ?? false
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if automaticallyDeselectRows {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        if let row = rowForIndexPath(indexPath) {
            row.selection?()
        }
    }

    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let row = rowForIndexPath(indexPath) {
            row.accessory.selection?()
        }
    }
    
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return rowForIndexPath(indexPath)?.canCopy ?? false
    }
    
    
    // The parameter indexPath: IndexPath? is optinal for a purpose. See: https://openradar.appspot.com/31375101
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath?, withSender sender: Any?) -> Bool {
        guard let indexPath = indexPath else { return false }
        return action == #selector(UIResponder.copy(_:)) && (rowForIndexPath(indexPath)?.canCopy ?? false)
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if let row = rowForIndexPath(indexPath), action == #selector(UIResponder.copy(_:)) {
            row.copyAction?(row)
        }
    }
}
