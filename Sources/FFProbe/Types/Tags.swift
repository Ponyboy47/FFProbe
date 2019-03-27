import struct Foundation.Date
import class Foundation.DateFormatter

public struct Tags {
    public var language: Language?
    public var handler: String?
    public var creation: Date?
    private static let _creationFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    public init() {}
}

extension Tags: Codable {
    public enum CodingKeys: String, CodingKey {
        case language
        case handler = "handler_name"
        case creation = "creation_time"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        language = try container.decodeIfPresent(Language.self, forKey: .language)
        handler = try container.decodeIfPresent(String.self, forKey: .handler)
        if let creationString = try container.decodeIfPresent(String.self, forKey: .creation) {
            creation = Tags._creationFormatter.date(from: creationString)
        } else {
            creation = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(language, forKey: .language)
        try container.encode(handler, forKey: .handler)
        if let creation = creation {
            try container.encode(Tags._creationFormatter.string(from: creation), forKey: .creation)
        }
    }
}

public enum Language: String, Codable {
    case eng, // English
        spa, // Spanish
        ita, // Italian
        fre, // French
        fin, // Finnish
        ger, // German
        por, // Portuguese
        dut, // Dutch
        jap, // Japanese
        chi, // Chinese
        rus, // Russian
        per, // Persian
        und // Undetermined
}
