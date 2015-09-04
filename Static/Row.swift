import UIKit

/// Row or Accessory selection callback.
public typealias Selection = () -> Void

/// Representation of a table row.
public struct Row: Hashable, Equatable {

    // MARK: - Types

    /// Representation of a row accessory.
    public enum Accessory: Equatable {
        /// No accessory
        case None

        /// Chevron
        case DisclosureIndicator

        /// Info button with chevron. Handles selection.
        case DetailDisclosureButton(Selection)

        /// Checkmark
        case Checkmark

        /// Info button. Handles selection.
        case DetailButton(Selection)

        /// Custom view
        case View(UIView)

        /// Table view cell accessory type
        public var type: UITableViewCellAccessoryType {
            switch self {
            case DisclosureIndicator: return .DisclosureIndicator
            case DetailDisclosureButton(_): return .DetailDisclosureButton
            case Checkmark: return .Checkmark
            case DetailButton(_): return .DetailButton
            default: return .None
            }
        }

        /// Accessory view
        public var view: UIView? {
            switch self {
            case View(let view): return view
            default: return nil
            }
        }

        /// Selection block for accessory buttons
        public var selection: Selection? {
            switch self {
            case DetailDisclosureButton(let selection): return selection
            case DetailButton(let selection): return selection
            default: return nil
            }
        }
    }

    public typealias Context = [String: Any]

    /// Representation of an editing action, when swiping to edit a cell.
    public struct EditAction {
        /// Title of the action's button.
        public let title: String
        
        /// Styling for button's action, used primarily for destructive actions.
        public let style: UITableViewRowActionStyle
        
        /// Background color of the button.
        public let backgroundColor: UIColor?
        
        /// Visual effect to be applied to the button's background.
        public let backgroundEffect: UIVisualEffect?
        
        /// Invoked when selecting the action.
        public let selection: Selection?
        
        public init(title: String, style: UITableViewRowActionStyle = .Default, backgroundColor: UIColor? = nil, backgroundEffect: UIVisualEffect? = nil, selection: Selection? = nil) {
            self.title = title
            self.style = style
            self.backgroundColor = backgroundColor
            self.backgroundEffect = backgroundEffect
            self.selection = selection
        }
    }

    // MARK: - Properties

    /// Unique identifier for the row.
    public let UUID: String

    /// The row's primary text.
    public var text: String?

    /// The row's secondary text.
    public var detailText: String?

    /// Accessory for the row.
    public var accessory: Accessory

    /// Image for the row
    public var image: UIImage?

    /// Action to run when the row is selected.
    public var selection: Selection?

    /// View to be used for the row.
    public var cellClass: CellType.Type

    /// Additional information for the row.
    public var context: Context?
    
    /// Actions to show when swiping the cell, such as Delete.
    public var editActions: [EditAction]

    var canEdit: Bool {
        return editActions.count > 0
    }

    var isSelectable: Bool {
        return selection != nil
    }

    var cellIdentifier: String {
        return cellClass.description()
    }

    public var hashValue: Int {
        return UUID.hashValue
    }


    // MARK: - Initializers

    public init(text: String? = nil, detailText: String? = nil, selection: Selection? = nil,
        image: UIImage? = nil, accessory: Accessory = .None, cellClass: CellType.Type? = nil, context: Context? = nil, editActions: [EditAction] = [], UUID: String = NSUUID().UUIDString) {
        self.UUID = UUID
        self.text = text
        self.detailText = detailText
        self.selection = selection
        self.image = image
        self.accessory = accessory
        self.cellClass = cellClass ?? Value1Cell.self
        self.context = context
        self.editActions = editActions
    }
}


public func ==(lhs: Row, rhs: Row) -> Bool {
    return lhs.UUID == rhs.UUID
}


public func ==(lhs: Row.Accessory, rhs: Row.Accessory) -> Bool {
    switch (lhs, rhs) {
    case (.None, .None): return true
    case (.DisclosureIndicator, .DisclosureIndicator): return true
    case (.DetailDisclosureButton(_), .DetailDisclosureButton(_)): return true
    case (.Checkmark, .Checkmark): return true
    case (.DetailButton(_), .DetailButton(_)): return true
    case (.View(let l), .View(let r)): return l == r
    default: return false
    }
}
