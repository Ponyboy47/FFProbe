import struct Foundation.CharacterSet

public struct SampleRate: RawRepresentable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    public enum Unit: String {
        case hz = "Hz"
        case khz = "kHz"
        case mhz = "mHz"
    }

    public let rawValue: (Double, Unit)
    public static let unknown: SampleRate = SampleRate(rawValue: (-1, .hz))

    public var value: Double { return rawValue.0 }
    public var unit: Unit { return rawValue.1 }

    public var hz: Double {
        switch unit {
        case .hz: return value
        case .khz: return value * 1000.0
        case .mhz: return value * 1000.0 * 1000.0
        }
    }
    public var khz: Double {
        switch unit {
        case .hz: return value / 1000.0
        case .khz: return value
        case .mhz: return value * 1000.0
        }
    }
    public var mhz: Double {
        switch unit {
        case .hz: return value / 1000.0 / 1000.0
        case .khz: return value / 1000.0
        case .mhz: return value
        }
    }

    public init(stringLiteral value: String) {
        guard !value.isEmpty else {
            self = .unknown
            return
        }

        let components = value.components(separatedBy: .whitespaces)
        if components.count == 1, let val = Double(value) {
            rawValue = (val, .hz)
            return
        }
        guard let val = Double(components[0]) else {
            self = .unknown
            return
        }

        switch components[1] {
        case "mHz": rawValue = (val, .mhz)
        case "kHz": rawValue = (val, .khz)
        default: rawValue = (val, .hz)
        }
    }

    public init(integerLiteral value: Int) {
        self.init(rawValue: (Double(value), .hz))
    }

    public init(floatLiteral value: Double) {
        self.init(rawValue: (value, .hz))
    }

    public init(rawValue: (Double, Unit)) {
        self.rawValue = rawValue
    }
}

extension SampleRate: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let bitRateString = try container.decode(String.self)

        self.init(stringLiteral: bitRateString)

        guard self != .unknown else {
            throw SampleRateError.unsupportedStringFormat(bitRateString)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension SampleRate: Comparable, Equatable {
    public static func < (lhs: SampleRate, rhs: SampleRate) -> Bool {
        return lhs.khz < rhs.khz
    }

    public static func == (lhs: SampleRate, rhs: SampleRate) -> Bool {
        return lhs.khz == rhs.khz
    }
}

extension SampleRate: CustomStringConvertible {
    public var description: String {
        return "\(String(format: "%.01f", value)) \(unit)"
    }
}
