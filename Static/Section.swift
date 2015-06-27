import Foundation

public struct Section: Hashable, Equatable {
    public let UUID: String
    public var header: String?
    public var rows: [Row]
    public var footer: String?

    public var hashValue: Int {
        return UUID.hashValue
    }

    public init(UUID: String = NSUUID().UUIDString, header: String? = nil, rows: [Row] = [], footer: String? = nil) {
        self.UUID = UUID
        self.header = header
        self.rows = rows
        self.footer = footer
    }
}


public func ==(lhs: Section, rhs: Section) -> Bool {
    return lhs.UUID == rhs.UUID
}
