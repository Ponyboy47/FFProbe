public protocol FFProbeStream {
    var index: Int { get }
    var type: CodecType { get }
    var rawCodec: String { get }
    var tags: Tags? { get }
}

public class BaseStream: FFProbeStream {
    public let index: Int
    public private(set) var type: CodecType
    public let rawCodec: String
    public let tags: Tags?

    public required init(_ any: AnyStream) throws {
        index = any.index
        type = any.type
        rawCodec = any.rawCodec
        tags = any.tags
    }
}

public final class AnyStream: FFProbeStream, Decodable {
    public let index: Int
    public let type: CodecType
    public let rawCodec: String
    public let tags: Tags?
    public let duration: MediaDuration?
    public let bitRate: BitRate?
    public let sampleRate: SampleRate?
    public let channels: Int?
    public let channelLayout: ChannelLayout?
    public let dimensions: (width: Int, height: Int)?
    public let aspectRatio: AspectRatio?
    public let frameRate: FrameRate?
    public let bitDepth: Int?

    public enum CodingKeys: String, CodingKey {
        case index
        case type = "codec_type"
        case rawCodec = "codec_name"
        case duration
        case bitRate = "bit_rate"
        case width
        case height
        case aspectRatio = "display_aspect_ratio"
        case frameRate = "avg_frame_rate"
        case bitDepth = "bits_per_raw_sample"
        case sampleRate = "sample_rate"
        case channels
        case channelLayout = "channel_layout"
        case tags
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        index = try container.decode(Int.self, forKey: .index)
        type = try container.decode(CodecType.self, forKey: .type)
        rawCodec = try container.decode(String.self, forKey: .rawCodec)
        tags = try container.decodeIfPresent(Tags.self, forKey: .tags)
        duration = try container.decodeIfPresent(MediaDuration.self, forKey: .duration)
        bitRate = try container.decodeIfPresent(BitRate.self, forKey: .bitRate)
        sampleRate = try container.decodeIfPresent(SampleRate.self, forKey: .sampleRate)
        channels = try container.decodeIfPresent(Int.self, forKey: .channels)
        channelLayout = try container.decodeIfPresent(ChannelLayout.self, forKey: .channelLayout)
        if let width = try container.decodeIfPresent(Int.self, forKey: .width), let height = try container.decodeIfPresent(Int.self, forKey: .height) {
            dimensions = (width: width, height: height)
        } else {
            dimensions = nil
        }

        aspectRatio = try container.decodeIfPresent(AspectRatio.self, forKey: .aspectRatio)
        frameRate = try container.decodeIfPresent(FrameRate.self, forKey: .frameRate)

        if let depth = try container.decodeIfPresent(String.self, forKey: .bitDepth) {
            bitDepth = Int(depth)
        } else {
            bitDepth = nil
        }
    }
}
