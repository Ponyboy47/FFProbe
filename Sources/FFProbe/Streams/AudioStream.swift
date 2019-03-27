public final class AudioStream: BaseStream {
    public override var type: CodecType { return .audio }
    public let codec: AudioCodec
    public let duration: MediaDuration?
    public let bitRate: BitRate?
    public let sampleRate: SampleRate
    public let channels: Int
    public let channelLayout: ChannelLayout?

    public required init(_ any: AnyStream) throws {
        guard let codec = AudioCodec(rawValue: any.rawCodec) else {
            throw AudioStreamError.unknownCodec(any.rawCodec)
        }
        self.codec = codec
        duration = any.duration
        bitRate = any.bitRate

        guard let sampleRate = any.sampleRate else {
            throw AudioStreamError.missingSampleRate
        }
        self.sampleRate = sampleRate

        guard let channels = any.channels else {
            throw AudioStreamError.missingChannels
        }
        self.channels = channels

        channelLayout = any.channelLayout

        try! super.init(any)
    }
}

extension AudioStream: CustomStringConvertible {
    public var description: String {
        var desc = "\(Swift.type(of: self))(index: \(index), codec: \(codec)"

        if let duration = self.duration {
            desc += ", duration: \(duration)"
        }
        if let bitRate = self.bitRate {
            desc += ", bitRate: \(bitRate)"
        }
        desc += ", sampleRate: \(sampleRate), channels: \(channels)"
        if let channelLayout = self.channelLayout {
            desc += ", channelLayout: \(channelLayout)"
        }

        return desc + ")"
    }
}
