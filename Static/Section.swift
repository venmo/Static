import Foundation

struct Section: Hashable, Equatable {
    let UUID: String
    var header: String?
    var footer: String?
    var rows: [Row]

    var hashValue: Int {
        return UUID.hashValue
    }

    init(UUID: String = NSUUID().UUIDString, header: String? = nil, footer: String? = nil, rows: [Row]) {
        self.UUID = UUID
        self.header = header
        self.footer = footer
        self.rows = rows
    }
}


func ==(lhs: Section, rhs: Section) -> Bool {
    return lhs.UUID == rhs.UUID
}
