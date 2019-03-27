public final class SubtitleStream: BaseStream {
    public override var type: CodecType { return .subtitle }
    public let codec: SubtitleCodec
    public let duration: MediaDuration?
    public let bitRate: BitRate?

    public required init(_ any: AnyStream) throws {
        guard let codec = SubtitleCodec(rawValue: any.rawCodec) else {
            throw SubtitleStreamError.unknownCodec(any.rawCodec)
        }
        self.codec = codec

        duration = any.duration
        bitRate = any.bitRate

        try! super.init(any)
    }
}

extension SubtitleStream: CustomStringConvertible {
    public var description: String {
        var desc = "\(Swift.type(of: self))(index: \(index), codec: \(codec)"

        if let duration = self.duration {
            desc += ", duration: \(duration)"
        }
        if let bitRate = self.bitRate {
            desc += ", bitRate: \(bitRate)"
        }

        return desc + ")"
    }
}
