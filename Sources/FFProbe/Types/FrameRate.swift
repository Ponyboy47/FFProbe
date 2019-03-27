import struct Foundation.CharacterSet

public struct FrameRate: RawRepresentable, ExpressibleByFloatLiteral, ExpressibleByStringLiteral {
    public let rawValue: Double

    public static let unknown: FrameRate = -1.0

    public init(stringLiteral value: String) {
        if value.contains("/") {
            let components = value.components(separatedBy: "/").map { $0.trimmingCharacters(in: .whitespaces) }
            guard components.count == 2, let numerator = Double(components[0]), let denominator = Double(components[1]) else {
                self = .unknown
                return
            }
            self.init(floatLiteral: numerator / denominator)
        } else {
            guard let fps = Double(value) else {
                self = .unknown
                return
            }
            self.init(floatLiteral: fps)
        }
    }

    public init(floatLiteral value: Double) {
        self.init(rawValue: value)
    }

    public init(rawValue: Double) {
        self.rawValue = rawValue < 0 ? 0 : rawValue
    }
}

extension FrameRate: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.init(floatLiteral: try container.decode(Double.self))
        } catch {
            self.init(stringLiteral: try container.decode(String.self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension FrameRate: CustomStringConvertible {
    public var description: String {
        return "\(String(format: "%.01f", rawValue)) fps"
    }
}
