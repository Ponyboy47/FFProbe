public protocol Codec {
    init?(rawValue: String)
}

public enum VideoCodec: String, Codable, Codec {
    case hevc
    case h264
    case mpeg4
    case mjpeg
    case mpeg1video
    case mpeg2video
    case vc1
    case msmpeg4
    case msmpeg4v2
}

public enum AudioCodec: String, Codable, Codec {
    case aac
    case ac3
    case eac3
    case mp2
    case mp3
    case truehd
    case dca
}

public enum SubtitleCodec: String, Codable, Codec {
    case srt
    case mov_text
    case dvdsub
    case pgssub
}
