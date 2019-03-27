public final class DataStream: BaseStream {
    public override var type: CodecType { return .data }
    public let duration: MediaDuration?
    public let bitRate: BitRate?

    public required init(_ any: AnyStream) {
        duration = any.duration
        bitRate = any.bitRate

        try! super.init(any)
    }
}

extension DataStream: CustomStringConvertible {
    public var description: String {
        var desc = "\(Swift.type(of: self))(index: \(index)"

        if let duration = self.duration {
            desc += ", duration: \(duration)"
        }
        if let bitRate = self.bitRate {
            desc += ", bitRate: \(bitRate)"
        }

        return desc + ")"
    }
}
