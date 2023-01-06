//
//  NSImage.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/6.
//

import AVKit

extension NSImage {
    func resized(to newSize: NSSize, hasAlpha: Bool = true) async throws -> NSImage {
        try await withCheckedThrowingContinuation { continuation in
            guard isValid else {
                fatalError("Image is not valid!")
            }
            guard let bitmapImageRep = NSBitmapImageRep(
                bitmapDataPlanes: nil,
                pixelsWide: Int(newSize.width),
                pixelsHigh: Int(newSize.height),
                bitsPerSample: 8,
                samplesPerPixel: 4,
                hasAlpha: true,
                isPlanar: false,
                colorSpaceName: .calibratedRGB,
                bytesPerRow: 0,
                bitsPerPixel: 0
            ) else {
                fatalError("Can not initialize NSBitmapImageRep!")
            }
            bitmapImageRep.size = newSize
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapImageRep)
            let rect = NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            if !hasAlpha {
                NSColor.white.drawSwatch(in: rect)
                rect.fill()
            }
            draw(in: rect)
            NSGraphicsContext.restoreGraphicsState()
            let newImage = NSImage(size: newSize)
            newImage.addRepresentation(bitmapImageRep)
            continuation.resume(returning: newImage)
        }
    }

    func removedAlpha() async -> NSImage {
        let result = NSImage(size: size)
        result.lockFocus()
        let rect = NSRect(origin: .zero, size: size)
        NSColor.white.drawSwatch(in: rect)
        result.unlockFocus()
        return result
    }
}
