import struct Foundation.CharacterSet

public struct BitRate: RawRepresentable, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public enum Unit: String {
        case bps = "bit/s"
        case kbps = "Kbit/s"
        case mbps = "Mbit/s"
    }

    public let rawValue: (Double, Unit)
    public static let unknown: BitRate = BitRate(rawValue: (-1, .bps))

    public var value: Double { return rawValue.0 }
    public var unit: Unit { return rawValue.1 }

    public var bps: Double {
        switch unit {
        case .bps: return value
        case .kbps: return value * 1000.0
        case .mbps: return value * 1000.0 * 1000.0
        }
    }

    public var kbps: Double {
        switch unit {
        case .bps: return value / 1000.0
        case .kbps: return value
        case .mbps: return value * 1000.0
        }
    }

    public var mbps: Double {
        switch unit {
        case .bps: return value / 1000.0 / 1000.0
        case .kbps: return value / 1000.0
        case .mbps: return value
        }
    }

    public init(stringLiteral value: String) {
        guard !value.isEmpty else {
            self = .unknown
            return
        }

        let components = value.components(separatedBy: .whitespaces)
        if components.count == 1, let val = Double(value) {
            rawValue = (val, .bps)
            return
        }
        guard let val = Double(components[0]) else {
            self = .unknown
            return
        }

        switch components[1] {
        case "Mbit/s": rawValue = (val, .mbps)
        case "Kbit/s": rawValue = (val, .kbps)
        default: rawValue = (val, .bps)
        }
    }

    public init(integerLiteral value: Int) {
        self.init(rawValue: (Double(value), .bps))
    }

    public init(floatLiteral value: Double) {
        self.init(rawValue: (value, .bps))
    }

    public init(rawValue: (Double, Unit)) {
        self.rawValue = rawValue
    }
}

extension BitRate: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let bitRateString = try container.decode(String.self)

        self.init(stringLiteral: bitRateString)

        guard self != .unknown else {
            throw BitRateError.unsupportedStringFormat(bitRateString)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension BitRate: Comparable, Equatable {
    public static func < (lhs: BitRate, rhs: BitRate) -> Bool {
        return lhs.kbps < rhs.kbps
    }

    public static func == (lhs: BitRate, rhs: BitRate) -> Bool {
        return lhs.kbps == rhs.kbps
    }
}

extension BitRate: CustomStringConvertible {
    public var description: String {
        return "\(value) \(unit)"
    }
}
