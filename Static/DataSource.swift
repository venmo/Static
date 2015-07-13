import UIKit

/// Table view data source.
///
/// You should always access this object from the main thread since it talks to UIKit.
public class DataSource: NSObject {

    // MARK: - Properties

    /// The table view that will use this object as its data source.
    public weak var tableView: UITableView? {
        willSet {
            if let tableView = tableView {
                tableView.dataSource = nil
                tableView.delegate = nil
            }
        }

        didSet {
            assert(NSThread.isMainThread(), "You must access Static.DataSource from the main thread.")
            updateTableView()
        }
    }

    /// Sections to use in the table view.
    public var sections: [Section] {
        didSet {
            assert(NSThread.isMainThread(), "You must access Static.DataSource from the main thread.")
            refresh()
        }
    }

    private var registeredCellIdentifiers = Set<String>()


    // MARK: - Initializers

    /// Initialize with optional `tableView` and `sections`.
    public init(tableView: UITableView? = nil, sections: [Section]? = nil) {
        self.tableView = tableView
        self.sections = sections ?? []

        super.init()

        updateTableView()
    }

    deinit {
        // nil out the table view to ensure the table view data source and delegate niled out
        tableView = nil
    }


    // MARK: - Private

    private func updateTableView() {
        guard let tableView = tableView else { return }
        tableView.dataSource = self
        tableView.delegate = self
        refresh()
    }

    private func refresh() {
        refreshTableSections()
        refreshRegisteredCells()
    }

    private func sectionForIndex(index: Int) -> Section? {
        if sections.count <= index {
            assert(false, "Invalid section index: \(index)")
            return nil
        }

        return sections[index]
    }

    private func rowForIndexPath(indexPath: NSIndexPath) -> Row? {
        if let section = sectionForIndex(indexPath.section) {
            let rows = section.rows
            if rows.count >= indexPath.row {
                return rows[indexPath.row]
            }
        }

        assert(false, "Invalid index path: \(indexPath)")
        return nil
    }

    private func refreshTableSections(oldSections: [Section]? = nil) {
        guard let tableView = tableView else { return }
        guard let oldSections = oldSections else {
            tableView.reloadData()
            return
        }

        let oldCount = oldSections.count
        let newCount = sections.count
        let delta = newCount - oldCount
        let animation: UITableViewRowAnimation = .Automatic

        tableView.beginUpdates()

        if delta == 0 {
            tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, newCount)), withRowAnimation: animation)
        } else {
            if delta > 0 {
                // Insert sections
                tableView.insertSections(NSIndexSet(indexesInRange: NSMakeRange(oldCount - 1, delta)), withRowAnimation: animation)
            } else {
                // Remove sections
                tableView.deleteSections(NSIndexSet(indexesInRange: NSMakeRange(oldCount - 1, -delta)), withRowAnimation: animation)
            }

            // Reload existing sections
            let commonCount = min(oldCount, newCount)
            tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, commonCount)), withRowAnimation: animation)
        }

        tableView.endUpdates()
    }

    private func refreshRegisteredCells() {
        // Filter to only rows with unregistered cells
        let rows = sections.map({ $0.rows }).reduce([], combine: +).filter() {
            !self.registeredCellIdentifiers.contains($0.cellIdentifier)
        }

        for row in rows {
            let identifier = row.cellIdentifier

            // Check again in case there were duplicate new cell classes
            if registeredCellIdentifiers.contains(identifier) {
                continue
            }

            registeredCellIdentifiers.insert(identifier)
            tableView?.registerClass(row.cellClass, forCellReuseIdentifier: identifier)
        }
    }
}


extension DataSource: UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionForIndex(section)?.rows.count ?? 0
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let row = rowForIndexPath(indexPath) {
            let tableCell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier, forIndexPath: indexPath)

            if let cell = tableCell as? CellType {
                cell.configure(row: row)
            }

            return tableCell
        }

        return UITableViewCell()
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionForIndex(section)?.header?.title
    }

    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionForIndex(section)?.header?.view
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionForIndex(section)?.header?.viewHeight ?? UITableViewAutomaticDimension
    }

    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sectionForIndex(section)?.footer?.title
    }

    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sectionForIndex(section)?.footer?.view
    }

    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionForIndex(section)?.footer?.viewHeight ?? UITableViewAutomaticDimension
    }
}

extension DataSource: UITableViewDelegate {
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return rowForIndexPath(indexPath)?.isSelectable ?? false
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if let row = rowForIndexPath(indexPath) {
            row.selection?()
        }
    }

    public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if let row = rowForIndexPath(indexPath) {
            row.accessory.selection?()
        }
    }
}
