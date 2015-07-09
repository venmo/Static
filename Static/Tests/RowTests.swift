import XCTest
import Static

class RowTests: XCTestCase {

    func testInit() {
        let selection: Void -> Void = {}
        let accessory = UIView()
        let context = [
            "Hello": "world"
        ]

        let row = Row(text: "Title", detailText: "Detail", accessoryType: .Checkmark, accessoryView: accessory, selection: selection, cellClass: ButtonCell.self, context: context, UUID: "1234")
        XCTAssertEqual("1234", row.UUID)
        XCTAssertEqual("Title", row.text!)
        XCTAssertEqual("Detail", row.detailText!)
        XCTAssertEqual(.Checkmark, row.accessoryType)
        XCTAssertEqual(accessory, row.accessoryView!)
        XCTAssertEqual(context["Hello"]!, row.context!["Hello"] as! String)
        XCTAssertTrue(row.isSelectable)
        XCTAssertNotNil(row.cellIdentifier)
    }

    func testHashable() {
        let row = Row()
        var hash = [
            row: "hi"
        ]

        XCTAssertEqual("hi", hash[row]!)
    }

    func testEquatable() {
        let row1 = Row()
        let row2 = Row()

        XCTAssertEqual(row1, row1)
        XCTAssertFalse(row1 == row2)
    }
}
