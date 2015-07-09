import UIKit

public class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    // MARK: - Properties

    /// The table view that will use this as its data source.
    public weak var tableView: UITableView? {
        willSet {
            if let tableView = tableView {
                tableView.dataSource = nil
                tableView.delegate = nil
            }
        }

        didSet {
            updateTableView()
        }
    }

    /// Static sections to use in the table view.
    public var sections = [Section]() {
        didSet {
            refresh()
        }
    }

    private var registeredCellIdentifiers = Set<String>()


    // MARK: - Initializers

    public init(tableView: UITableView? = nil) {
        super.init()
        self.tableView = tableView
        updateTableView()
    }

    deinit {
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


extension DataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let s = sectionForIndex(section) {
            return s.rows.count
        }

        return 0
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
        if let s = sectionForIndex(section) {
            return s.header
        }
        return nil
    }

    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let s = sectionForIndex(section) {
            return s.footer
        }
        return nil
    }
}

extension DataSource {
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let row = rowForIndexPath(indexPath) {
            return row.isSelectable
        }
        return false
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if let row = rowForIndexPath(indexPath) {
            row.selection?()
        }
    }
}
