import XCTest
import Static

class SectionTests: XCTestCase {

    func testInit() {
        let rows = [Row(text: "Row")]
        let section = Section(UUID: "1234", header: "Header", rows: rows, footer: "Footer")
        XCTAssertEqual("1234", section.UUID)
        XCTAssertEqual("Header", section.header!)
        XCTAssertEqual(rows, section.rows)
        XCTAssertEqual("Footer", section.footer!)
    }
}
