import UIKit

public class TableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    // MARK: - Properties

    private weak var tableView: UITableView?
    weak var tableViewDataSource: UITableViewDataSource?
    weak var tableViewDelegate: UITableViewDelegate?

    public var sections = [Section]() {
        didSet {
            refreshTableSections(oldValue)
            refreshRegisteredCells()
        }
    }

    private var registeredCellIdentifiers = Set<String>()


    // MARK: - Initializers

    public required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    // MARK: - Private

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

    private func refreshTableSections(oldSections: [Section]) {
        if let tableView = tableView {
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


// Forwarded or implemented UITableViewDataSource methods
extension TableDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = tableViewDataSource {
            return dataSource.tableView(tableView, numberOfRowsInSection: section)
        }

        if let s = sectionForIndex(section) {
            return s.rows.count
        }

        return 0
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let dataSource = tableViewDataSource {
            return dataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }

        if let row = rowForIndexPath(indexPath) {
            let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = row.text
            cell.detailTextLabel?.text = row.detailText
            cell.accessoryType = row.accessory
            return cell
        }

        return UITableViewCell()
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let dataSource = tableViewDataSource, f = dataSource.numberOfSectionsInTableView {
            return f(tableView)
        }

        return sections.count
    }

    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let dataSource = tableViewDataSource, f = dataSource.tableView:titleForHeaderInSection: {
            return f(tableView, titleForHeaderInSection: section)
        }

        if let s = sectionForIndex(section) {
            return s.header
        }
        return nil
    }

    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let dataSource = tableViewDataSource, f = dataSource.tableView:titleForFooterInSection: {
            return f(tableView, titleForFooterInSection: section)
        }

        if let s = sectionForIndex(section) {
            return s.footer
        }
        return nil
    }
}


// Forward UITableViewDataSource methods
extension TableDataSource {
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tableViewDataSource?.tableView?(tableView, canEditRowAtIndexPath: indexPath) ?? false
    }

    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tableViewDataSource?.tableView?(tableView, canMoveRowAtIndexPath: indexPath) ?? false
    }

    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return tableViewDataSource?.sectionIndexTitlesForTableView?(tableView)
    }

    public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return tableViewDataSource?.tableView?(tableView, sectionForSectionIndexTitle: title, atIndex: index) ?? 0
    }

    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        tableViewDataSource?.tableView?(tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        tableViewDataSource?.tableView?(tableView, moveRowAtIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}


// Forwarded or implemented UITableViewDelegate methods
extension TableDataSource {
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let delegate = tableViewDelegate, f = delegate.tableView:shouldHighlightRowAtIndexPath: {
            return f(tableView, shouldHighlightRowAtIndexPath: indexPath)
        }

        if let row = rowForIndexPath(indexPath) {
            return row.isSelectable
        }
        return false
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = tableViewDelegate, f = delegate.tableView:didSelectRowAtIndexPath: {
            f(tableView, didSelectRowAtIndexPath: indexPath)
            return
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if let row = rowForIndexPath(indexPath) {
            row.selection?()
        }
    }
}


// Forward UITableViewDelegate methods
extension TableDataSource {
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableViewDelegate?.tableView?(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        tableViewDelegate?.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
    }

    public func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        tableViewDelegate?.tableView?(tableView, willDisplayFooterView: view, forSection: section)
    }

    public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableViewDelegate?.tableView?(tableView, didEndDisplayingCell: cell, forRowAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        tableViewDelegate?.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }

    public func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        tableViewDelegate?.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewDelegate?.tableView?(tableView, heightForRowAtIndexPath: indexPath) ?? UITableViewAutomaticDimension
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewDelegate?.tableView?(tableView, heightForHeaderInSection: section) ?? UITableViewAutomaticDimension
    }

    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableViewDelegate?.tableView?(tableView, heightForFooterInSection: section) ?? UITableViewAutomaticDimension
    }

    // Note: estimated heights are not supported

    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewDelegate?.tableView?(tableView, viewForHeaderInSection: section)
    }

    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableViewDelegate?.tableView?(tableView, viewForFooterInSection: section)
    }

    public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        tableViewDelegate?.tableView?(tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableViewDelegate?.tableView?(tableView, didHighlightRowAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableViewDelegate?.tableView?(tableView, didUnhighlightRowAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return tableViewDelegate?.tableView?(tableView, willSelectRowAtIndexPath: indexPath) ?? indexPath
    }

    public func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return tableViewDelegate?.tableView?(tableView, willDeselectRowAtIndexPath: indexPath) ?? indexPath
    }

    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableViewDelegate?.tableView?(tableView, didDeselectRowAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return tableViewDelegate?.tableView?(tableView, editingStyleForRowAtIndexPath: indexPath) ?? .None
    }

    public func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return tableViewDelegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return tableViewDelegate?.tableView?(tableView, editActionsForRowAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tableViewDelegate?.tableView?(tableView, shouldIndentWhileEditingRowAtIndexPath: indexPath) ?? true
    }

    public func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        tableViewDelegate?.tableView?(tableView, willBeginEditingRowAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        tableViewDelegate?.tableView?(tableView, didEndEditingRowAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        return tableViewDelegate?.tableView?(tableView, targetIndexPathForMoveFromRowAtIndexPath: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath) ?? proposedDestinationIndexPath
    }

    public func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        return tableViewDelegate?.tableView?(tableView, indentationLevelForRowAtIndexPath: indexPath) ?? 0
    }

    public func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tableViewDelegate?.tableView?(tableView, shouldShowMenuForRowAtIndexPath: indexPath) ?? false
    }

    public func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return tableViewDelegate?.tableView?(tableView, canPerformAction: action, forRowAtIndexPath: indexPath, withSender: sender) ?? false
    }

    public func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        tableViewDelegate?.tableView?(tableView, performAction: action, forRowAtIndexPath: indexPath, withSender: sender)
    }
}


// Forward UIScrollViewDelegate methods
extension TableDataSource {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        tableViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    public func scrollViewDidZoom(scrollView: UIScrollView) {
        tableViewDelegate?.scrollViewDidZoom?(scrollView)
    }

    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        tableViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        tableViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        tableViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        tableViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        tableViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return tableViewDelegate?.viewForZoomingInScrollView?(scrollView)
    }

    public func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        tableViewDelegate?.scrollViewWillBeginZooming?(scrollView, withView: view)
    }

    public func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        tableViewDelegate?.scrollViewDidEndZooming?(scrollView, withView: view, atScale: scale)
    }

    public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        return tableViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    public func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        tableViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
