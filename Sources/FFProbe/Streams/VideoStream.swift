public final class VideoStream: BaseStream {
    public override var type: CodecType { return .video }
    public let codec: VideoCodec
    public let duration: MediaDuration?
    public let bitRate: BitRate?
    public let dimensions: (width: Int, height: Int)
    public let aspectRatio: AspectRatio
    public let frameRate: FrameRate
    public let bitDepth: Int?

    public required init(_ any: AnyStream) throws {
        guard let codec = VideoCodec(rawValue: any.rawCodec) else {
            throw VideoStreamError.unknownCodec(any.rawCodec)
        }
        self.codec = codec

        duration = any.duration
        bitRate = any.bitRate

        guard let dimensions = any.dimensions else {
            throw VideoStreamError.missingDimensions
        }
        self.dimensions = dimensions

        guard let aspectRatio = any.aspectRatio else {
            throw VideoStreamError.missingAspectRatio
        }
        self.aspectRatio = aspectRatio

        guard let frameRate = any.frameRate else {
            throw VideoStreamError.missingFrameRate
        }
        self.frameRate = frameRate

        bitDepth = any.bitDepth

        try! super.init(any)
    }
}

extension VideoStream: CustomStringConvertible {
    public var description: String {
        var desc = "\(Swift.type(of: self))(index: \(index), codec: \(codec)"

        if let duration = self.duration {
            desc += ", duration: \(duration)"
        }
        if let bitRate = self.bitRate {
            desc += ", bitRate: \(bitRate)"
        }
        desc += ", dimensions: \(dimensions), aspectRatio: \(aspectRatio), frameRate: \(frameRate)"
        if let bitDepth = self.bitDepth {
            desc += ", bitDepth: \(bitDepth)"
        }

        return desc + ")"
    }
}
