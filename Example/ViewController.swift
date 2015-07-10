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

        dataSource.sections = [
            Section(header: "Styles", rows: [
                Row(text: "Value 1", detailText: "Detail", cellClass: Value1Cell.self),
                Row(text: "Value 2", detailText: "Detail", cellClass: Value2Cell.self),
                Row(text: "Subtitle", detailText: "Detail", cellClass: SubtitleCell.self),
                Row(text: "Button", detailText: "Detail", cellClass: ButtonCell.self)
            ], footer: "This is a section footer."),
            Section(header: "Accessories", rows: [
                Row(text: "None"),
                Row(text: "Disclosure Indicator", accessory: .DisclosureIndicator),
                Row(text: "Detail Disclosure Button", accessory: .DetailDisclosureButton(detailDisclosureButtonSelected)),
                Row(text: "Checkmark", accessory: .Checkmark),
                Row(text: "Detail Button", accessory: .DetailButton(detailButtonSelected)),
                Row(text: "Custom View", accessory: .View(customAccessory))
            ], footer: "Try tapping the ⓘ buttons."),
            Section(header: "Selection", rows: [
                Row(text: "Tap this row", selection: selection)
            ])
        ]
    }


    // MARK: - Private

    private func detailDisclosureButtonSelected() {
        showAlert(title: "Detail Disclosure Button")
    }

    private func detailButtonSelected() {
        showAlert(title: "Detail Button")
    }

    private func selection() {
        showAlert(title: "Row Selection")
    }

    private func showAlert(title title: String? = nil, message: String? = "You tapped it. Good work.", button: String = "Thanks") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: button, style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
