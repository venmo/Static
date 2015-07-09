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

    func testHashable() {
        let section = Section()
        var hash = [
            section: "hi"
        ]

        XCTAssertEqual("hi", hash[section]!)
    }

    func testEquatable() {
        let section1 = Section()
        let section2 = Section()

        XCTAssertEqual(section1, section1)
        XCTAssertFalse(section1 == section2)
    }
}
