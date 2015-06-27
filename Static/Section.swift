import Foundation

public struct Section: Hashable, Equatable {
    public let UUID: String
    public var header: String?
    public var footer: String?
    public var rows: [Row]

    public var hashValue: Int {
        return UUID.hashValue
    }

    public init(UUID: String = NSUUID().UUIDString, header: String? = nil, footer: String? = nil, rows: [Row]) {
        self.UUID = UUID
        self.header = header
        self.footer = footer
        self.rows = rows
    }
}


public func ==(lhs: Section, rhs: Section) -> Bool {
    return lhs.UUID == rhs.UUID
}
