public struct AspectRatio: RawRepresentable, ExpressibleByFloatLiteral, ExpressibleByStringLiteral {
    public let rawValue: Double

    public static let x36x10: AspectRatio = .x3_6x1
    public static let x21x9: AspectRatio = .x7x3
    public static let x18x9: AspectRatio = .x2x1
    public static let x16x9 = AspectRatio(floatLiteral: 16.0 / 9.0)
    public static let x9x16: AspectRatio = 0.5625
    public static let x7x3 = AspectRatio(floatLiteral: 7.0 / 3.0)
    public static let x4x3 = AspectRatio(floatLiteral: 4.0 / 3.0)
    public static let x3_6x1: AspectRatio = 3.6
    public static let x2x1: AspectRatio = 2.0
    public static let square: AspectRatio = 1.0
    public static let vertical: AspectRatio = .x9x16
    public static let unknown: AspectRatio = -1.0

    public init(_ str: String, separatedBy delimiter: String = ":") {
        var comps = str.components(separatedBy: delimiter)

        if comps.count == 2 {
            rawValue = Double(comps[0])! / Double(comps[1])!
            print(str)
            print(rawValue)
        } else {
            self = .unknown
        }
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(floatLiteral value: Double) {
        self.init(rawValue: value)
    }

    public init(rawValue: Double) {
        self.rawValue = rawValue
    }
}

extension AspectRatio: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(container.decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension AspectRatio: Comparable, Equatable {
    public static func < (lhs: AspectRatio, rhs: AspectRatio) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension AspectRatio: CustomStringConvertible {
    public var description: String {
        switch self {
        case .x36x10: return "36:10"
        case .x16x9: return "16:9"
        case .x9x16: return "9:16"
        case .x7x3: return "7:3"
        case .x4x3: return "4:3"
        case .x2x1: return "2:1"
        case .square: return "1:1"
        case .unknown: return "unknown"
        default: return "\(String(format: "%.02f", rawValue))"
        }
    }
}
