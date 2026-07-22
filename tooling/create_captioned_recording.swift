import AppKit
import AVFoundation
import CoreGraphics
import CoreText
import Foundation

struct DemoFrame {
    let imagePath: String
    let caption: String
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let outputURL = root.appendingPathComponent(
    "store/recordings/coach-score-ios-demo-captioned.mp4"
)

let frames: [DemoFrame] = [
    DemoFrame(
        imagePath: "store/screenshots/ios/iphone-17/01-matches.png",
        caption: "Start or resume a match, then jump straight into scoring."
    ),
    DemoFrame(
        imagePath: "store/screenshots/ios/iphone-17/02-live-score.png",
        caption: "Select a player once, then tap large action buttons to record Coach Score."
    ),
    DemoFrame(
        imagePath: "store/screenshots/ios/iphone-17/03-recent-events.png",
        caption: "If a score is entered by mistake, void the event instead of deleting history."
    ),
    DemoFrame(
        imagePath: "store/screenshots/ios/iphone-17/04-match-summary.png",
        caption: "Review player totals, action totals, set totals, and export match data."
    ),
    DemoFrame(
        imagePath: "store/screenshots/ios/iphone-17/05-roster.png",
        caption: "Manage the roster, active players, and CSV imports offline."
    ),
    DemoFrame(
        imagePath: "store/screenshots/ios/iphone-17/06-rules.png",
        caption: "Customize scoring rules so Coach Score matches your coaching system."
    ),
]

let frameDurationSeconds = 3
let fps: Int32 = 30

func loadImage(_ relativePath: String) throws -> CGImage {
    let url = root.appendingPathComponent(relativePath)
    guard let image = NSImage(contentsOf: url) else {
        throw NSError(
            domain: "CaptionedRecording",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Could not load image: \(relativePath)"]
        )
    }
    var rect = CGRect(origin: .zero, size: image.size)
    guard let cgImage = image.cgImage(forProposedRect: &rect, context: nil, hints: nil) else {
        throw NSError(
            domain: "CaptionedRecording",
            code: 2,
            userInfo: [NSLocalizedDescriptionKey: "Could not decode image: \(relativePath)"]
        )
    }
    return cgImage
}

func makePixelBuffer(width: Int, height: Int) throws -> CVPixelBuffer {
    var pixelBuffer: CVPixelBuffer?
    let status = CVPixelBufferCreate(
        kCFAllocatorDefault,
        width,
        height,
        kCVPixelFormatType_32ARGB,
        [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true,
        ] as CFDictionary,
        &pixelBuffer
    )
    guard status == kCVReturnSuccess, let pixelBuffer else {
        throw NSError(
            domain: "CaptionedRecording",
            code: 3,
            userInfo: [NSLocalizedDescriptionKey: "Could not create pixel buffer"]
        )
    }
    return pixelBuffer
}

func drawCaption(_ caption: String, in context: CGContext, width: Int, height: Int) {
    let scale = CGFloat(width) / 1206.0
    let sidePadding = 58.0 * scale
    let bottomPadding = 88.0 * scale
    let captionHeight = 250.0 * scale
    let radius = 34.0 * scale
    let boxRect = CGRect(
        x: sidePadding,
        y: bottomPadding,
        width: CGFloat(width) - sidePadding * 2,
        height: captionHeight
    )

    context.setFillColor(CGColor(red: 0.02, green: 0.09, blue: 0.08, alpha: 0.82))
    context.addPath(CGPath(roundedRect: boxRect, cornerWidth: radius, cornerHeight: radius, transform: nil))
    context.fillPath()

    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    paragraph.lineBreakMode = .byWordWrapping

    let fontSize = 48.0 * scale
    let attributed = NSAttributedString(
        string: caption,
        attributes: [
            .font: NSFont.systemFont(ofSize: fontSize, weight: .semibold),
            .foregroundColor: NSColor.white,
            .paragraphStyle: paragraph,
        ]
    )

    let textRect = boxRect.insetBy(dx: 42.0 * scale, dy: 38.0 * scale)
    let framesetter = CTFramesetterCreateWithAttributedString(attributed)
    let path = CGPath(rect: textRect, transform: nil)
    let textFrame = CTFramesetterCreateFrame(
        framesetter,
        CFRange(location: 0, length: attributed.length),
        path,
        nil
    )
    CTFrameDraw(textFrame, context)
}

func drawFrame(_ demoFrame: DemoFrame, width: Int, height: Int) throws -> CVPixelBuffer {
    let image = try loadImage(demoFrame.imagePath)
    let pixelBuffer = try makePixelBuffer(width: width, height: height)

    CVPixelBufferLockBaseAddress(pixelBuffer, [])
    defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }

    guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
        throw NSError(
            domain: "CaptionedRecording",
            code: 4,
            userInfo: [NSLocalizedDescriptionKey: "Could not lock pixel buffer"]
        )
    }

    guard let context = CGContext(
        data: baseAddress,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
    ) else {
        throw NSError(
            domain: "CaptionedRecording",
            code: 5,
            userInfo: [NSLocalizedDescriptionKey: "Could not create drawing context"]
        )
    }

    context.setFillColor(CGColor(red: 0.94, green: 0.98, blue: 0.96, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
    drawCaption(demoFrame.caption, in: context, width: width, height: height)

    return pixelBuffer
}

func createVideo() async throws {
    if FileManager.default.fileExists(atPath: outputURL.path) {
        try FileManager.default.removeItem(at: outputURL)
    }

    let firstImage = try loadImage(frames[0].imagePath)
    let width = firstImage.width
    let height = firstImage.height

    let writer = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
    let input = AVAssetWriterInput(
        mediaType: .video,
        outputSettings: [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 4_000_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
            ],
        ]
    )
    input.expectsMediaDataInRealTime = false

    let adaptor = AVAssetWriterInputPixelBufferAdaptor(
        assetWriterInput: input,
        sourcePixelBufferAttributes: [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
        ]
    )

    guard writer.canAdd(input) else {
        throw NSError(
            domain: "CaptionedRecording",
            code: 6,
            userInfo: [NSLocalizedDescriptionKey: "Could not add video input"]
        )
    }
    writer.add(input)

    writer.startWriting()
    writer.startSession(atSourceTime: .zero)

    var presentationFrame: Int64 = 0
    let repeatedFrames = frameDurationSeconds * Int(fps)

    for demoFrame in frames {
        let pixelBuffer = try drawFrame(demoFrame, width: width, height: height)
        for _ in 0..<repeatedFrames {
            while !input.isReadyForMoreMediaData {
                Thread.sleep(forTimeInterval: 0.01)
            }
            let time = CMTime(value: presentationFrame, timescale: fps)
            guard adaptor.append(pixelBuffer, withPresentationTime: time) else {
                throw writer.error ?? NSError(
                    domain: "CaptionedRecording",
                    code: 7,
                    userInfo: [NSLocalizedDescriptionKey: "Could not append frame"]
                )
            }
            presentationFrame += 1
        }
    }

    input.markAsFinished()
    await withCheckedContinuation { continuation in
        writer.finishWriting {
            continuation.resume()
        }
    }

    if writer.status != .completed {
        throw writer.error ?? NSError(
            domain: "CaptionedRecording",
            code: 8,
            userInfo: [NSLocalizedDescriptionKey: "Video writer failed"]
        )
    }

    print("Wrote \(outputURL.path)")
}

do {
    try await createVideo()
} catch {
    fputs("Failed: \(error.localizedDescription)\n", stderr)
    exit(1)
}
