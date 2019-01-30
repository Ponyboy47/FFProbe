import func SwiftShell.run
import struct TrailBlazer.FilePath
import class Foundation.JSONDecoder

public final class FFProbe: Decodable {
    public let path: FilePath

    public let video: [VideoStream]
    public let audio: [AudioStream]
    public let subtitle: [SubtitleStream]
    public let data: [DataStream]

    public enum CodingKeys: String, CodingKey {
        case streams
    }

    public convenience init(from string: String) throws {
        guard let file = FilePath(string) else {
            throw PathError.notAFile(string)
        }

        try self.init(from: file)
    }

    public init(from path: FilePath) throws {
        let ffprobeResponse = SwiftShell.run("ffprobe", ["-hide_banner", "-of", "json", "-show_streams", "\((path.absolute ?? path).string)"])

        guard ffprobeResponse.succeeded else {
            throw FFProbeError.couldNotGetMetadata(ffprobeResponse.stderror)
        }
        guard !ffprobeResponse.stdout.isEmpty else {
            throw FFProbeError.emptyMetadata(for: path)
        }

        let copy = try JSONDecoder().decode(FFProbe.self, from: ffprobeResponse.stdout.data(using: .utf8)!)

        self.path = path
        video = copy.video
        audio = copy.audio
        subtitle = copy.subtitle
        data = copy.data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let streams = try container.decode([AnyStream].self, forKey: .streams)

        video = try streams.filter({ $0.type == .video }).map(VideoStream.init)
        audio = try streams.filter({ $0.type == .audio }).map(AudioStream.init)
        subtitle = try streams.filter({ $0.type == .subtitle }).map(SubtitleStream.init)
        data = streams.filter({ $0.type == .data }).map(DataStream.init)

        path = FilePath("")!
    }
}

extension FFProbe: CustomStringConvertible {
    public var description: String {
        return "\(type(of: self))(path: \(path), video: \(video), audio: \(audio), subtitle: \(subtitle), data: \(data))"
    }
}
