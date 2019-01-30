public struct MediaDuration: RawRepresentable, ExpressibleByStringLiteral {
    public let rawValue: Int

    public let hours: Int
    public let minutes: Int
    public let seconds: Int

    public static let unknown = MediaDuration(rawValue: -1)

    public init(stringLiteral value: String) {
        let parts = value.components(separatedBy: ":")

        guard !parts.isEmpty else {
            self = .unknown
            return
        }

        if parts.count == 3 {
            hours = Int(parts[0])!
            minutes = Int(parts[1])!
            seconds = Int(parts[2])!
        } else if parts.count == 2 {
            hours = 0
            minutes = Int(parts[0])!
            seconds = Int(parts[1])!
        } else {
            let secs = Int(Double(value)!)
            let mins = secs / 60
            hours = mins / 60

            seconds = secs % 60
            minutes = mins % 60
        }

        rawValue = seconds + (minutes * 60) + (hours * 60 * 60)
    }

    public init(rawValue: Int) {
        self.rawValue = rawValue

        seconds = rawValue % 60
        let mins = rawValue / 60
        hours = mins / 60
        minutes = mins % 60
    }
}

extension MediaDuration: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(stringLiteral: try container.decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension MediaDuration: Comparable, Equatable {
    public static func < (lhs: MediaDuration, rhs: MediaDuration) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func == (lhs: MediaDuration, rhs: MediaDuration) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension MediaDuration: CustomStringConvertible {
    public var description: String {
        var str = ""
        if hours > 0 {
            str += "\(hours):"
        }

        if hours > 0 || minutes > 0 {
            str += String(format: "%02d:", minutes)
        }

        str += String(format: "%02d", seconds)
        return str
    }
}
