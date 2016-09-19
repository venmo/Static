import UIKit
import Static

class ViewController: TableViewController {

    // MARK: - Properties

    private let customAccessory: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = .red
        return view
    }()


    // MARK: - Initializers

    convenience init() {
        self.init(style: .grouped)
    }


    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Static"
        
        tableView.rowHeight = 50

        dataSource.sections = [
            Section(header: "Styles", rows: [
                Row(text: "Value 1", detailText: "Detail", cellClass: Value1Cell.self),
                Row(text: "Value 1", detailText: "with an image", image: UIImage(named: "Settings"), cellClass: Value1Cell.self),
                Row(text: "Value 2", detailText: "Detail", cellClass: Value2Cell.self),
                Row(text: "Subtitle", detailText: "Detail", cellClass: SubtitleCell.self),
                Row(text: "Button", detailText: "Detail", selection: { [unowned self] in
                    self.showAlert(title: "Row Selection")
                }, cellClass: ButtonCell.self),
                Row(text: "Custom from nib", cellClass: NibTableViewCell.self)
            ], footer: "This is a section footer."),
            Section(header: "Accessories", rows: [
                Row(text: "None"),
                Row(text: "Disclosure Indicator", accessory: .disclosureIndicator),
                Row(text: "Detail Disclosure Button", accessory: .detailDisclosureButton({ [unowned self] in
                    self.showAlert(title: "Detail Disclosure Button")
                })),
                Row(text: "Checkmark", accessory: .checkmark),
                Row(text: "Detail Button", accessory: .detailButton({ [unowned self] in
                    self.showAlert(title: "Detail Button")
                })),
                Row(text: "Custom View", accessory: .view(customAccessory))
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
                    Row.EditAction(title: "Warn", backgroundColor: .orange, selection: { [unowned self] in
                        self.showAlert(title: "Warned.")
                    }),
                    Row.EditAction(title: "Delete", style: .destructive, selection: { [unowned self] in
                        self.showAlert(title: "Deleted.")
                    })
                ])
            ])
        ]
    }


    // MARK: - Private

    private func showAlert(title: String? = nil, message: String? = "You tapped it. Good work.", button: String = "Thanks") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
