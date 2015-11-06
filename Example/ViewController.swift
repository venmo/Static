import UIKit
import Static

class ViewController: TableViewController, UIGestureRecognizerDelegate {
    var originalCenter = CGPoint()
    var leftDragRelease = false
    var rightDragRelease = false

    // MARK: - Properties

    private let customAccessory: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = .redColor()
        return view
    }()


    // MARK: - Initializers

    convenience init() {
        self.init(style: .Grouped)
    }


    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Static"
        
        tableView.rowHeight = 66

        let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self;

        dataSource.sections = [
            Section(header: "Styles", rows: [
                Row(text: "Value 1", detailText: "Detail", cellClass: Value1Cell.self),
                Row(text: "Value 1", detailText: "with an image", cellClass: Value1Cell.self, image: UIImage(named: "Settings")),
                Row(text: "Value 1", detailText: "with a green tinted image", cellClass: Value1Cell.self, image: UIImage(named: "Settings"), imageTintColor: UIColor.greenColor()),
                Row(text: "Value 2", detailText: "Detail", cellClass: Value2Cell.self),
                Row(text: "Subtitle", detailText: "Detail", cellClass: SubtitleCell.self),
                Row(text: "Button", detailText: "Detail", cellClass: ButtonCell.self, selection: { [unowned self] in
                    self.showAlert(title: "Row Selection")
                }),
                Row(text: "Custom cell with explicit height", cellClass: CustomTableViewCell.self, height: 44),
                Row(text: "Custom from nib", cellClass: NibTableViewCell.self, height: UITableViewAutomaticDimension)
            ], footer: "This is a section footer."),
            Section(header: "Accessories", rows: [
                Row(text: "None"),
                Row(text: "Disclosure Indicator", accessory: .DisclosureIndicator),
                Row(text: "Detail Disclosure Button", accessory: .DetailDisclosureButton({ [unowned self] in
                    self.showAlert(title: "Detail Disclosure Button")
                })),
                Row(text: "Checkmark", accessory: .Checkmark),
                Row(text: "Detail Button", accessory: .DetailButton({ [unowned self] in
                    self.showAlert(title: "Detail Button")
                })),
                Row(text: "Custom View", accessory: .View(customAccessory))
            ], footer: "Try tapping the ⓘ buttons."),
            Section(header: "Selection", rows: [
                Row(text: "Tap this row", selection: { [unowned self] in
                    self.showAlert(title: "Row Selection")
                }),
                Row(text: "Tap this row", selection: { [unowned self] in
                    let viewController = ViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                })
            ]),
            Section(header: "Editing", rows: [
                Row(text: "Swipe this row", editActions: [
                    Row.EditAction(title: "Warn", backgroundColor: .orangeColor(), selection: { [unowned self] in
                        self.showAlert(title: "Warned.")
                    }),
                    Row.EditAction(title: "Delete", style: .Destructive, selection: { [unowned self] in
                        self.showAlert(title: "Deleted.")
                    })
                ]),
                Row(text: "Gesture recognizer", detailText: "Swipe left/right", cellClass: SubtitleCell.self, gestureRecognizer:recognizer)
            ])
        ]
    }


    // MARK: - Private

    private func showAlert(title title: String? = nil, message: String? = "You tapped it. Good work.", button: String = "Thanks") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: button, style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Gesture Recognizer
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let cell = recognizer.view as! UITableViewCell
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = cell.center
        }
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(cell)
            cell.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            //dragged the item far enough?
            leftDragRelease = cell.frame.origin.x < -cell.frame.size.width / 2.0
            rightDragRelease = cell.frame.origin.x > cell.frame.size.width / 2.0
        }
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: cell.frame.origin.y,
                width: cell.bounds.size.width, height: cell.bounds.size.height)
            if leftDragRelease {
                self.showAlert(title: "Left swipe", message: cell.textLabel?.text)
            }
            if rightDragRelease {
                self.showAlert(title: "Right swipe", message: cell.textLabel?.text)
            }
            UIView.animateWithDuration(0.2, animations: {cell.frame = originalFrame})
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        //Determine whether the pan that is about to be initiated is horizontal or vertical. If it
        //is vertical, we cancel the gesture recognizer, since we don’t want to handle any
        //vertical pans.
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(gestureRecognizer.view!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}
