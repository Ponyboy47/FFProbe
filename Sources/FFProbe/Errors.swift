import struct TrailBlazer.FilePath

public enum PathError: Error {
    case notAFile(String)
}

public enum BitRateError: Error {
    case unsupportedStringFormat(String)
}

public enum SampleRateError: Error {
    case unsupportedStringFormat(String)
}

public enum FFProbeError: Error {
    case couldNotGetMetadata(String)
    case emptyMetadata(for: FilePath)
}

public enum VideoStreamError: Error {
    case unknownCodec(String)
    case missingDimensions
    case missingAspectRatio
    case missingFrameRate
}

public enum AudioStreamError: Error {
    case unknownCodec(String)
    case missingSampleRate
    case missingChannels
}

public enum SubtitleStreamError: Error {
    case unknownCodec(String)
}
