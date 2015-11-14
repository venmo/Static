import UIKit
import Static

class ViewController: TableViewController {

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
                Row(text: "Custom from nib", cellClass: NibTableViewCell.self)
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
                ])
            ])
        ]
    }


    // MARK: - Private

    private func showAlert(title title: String? = nil, message: String? = "You tapped it. Good work.", button: String = "Thanks") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: button, style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
