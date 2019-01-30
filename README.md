# FFProbe

A utility for processing output from the `ffprobe` command that comes with ffmpeg

## Installation
Swift Package Manager
```swift
.package(url: "https://github.com/Ponyboy47/FFProbe.git", from: "0.1.0")
```

## Usage
```
import FFProbe

let probe = try FFProbe(from: "/path/to/media/file")

// [VideoStream]
print(probe.video)

// [AudioStream]
print(probe.audio)

// [SubtitleStream]
print(probe.subtitle)

// [DataStream]
print(probe.data)
```

## License
MIT
