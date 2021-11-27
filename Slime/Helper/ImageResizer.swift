//
//  ImageResizer.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import AppKit
import Foundation

class ImageResizer {
    var imageURL: URL?

    func generateImages(for sizes: [CGSize]) async throws -> [NSImage] {
        guard let imageURL = imageURL, let image = NSImage(contentsOf: imageURL) else {
            return []
        }
        var images: [NSImage] = []
        for size in sizes {
            let image = try await image.resized(to: size)
            images.append(image)
        }
        return images
    }

    func generateImage(for size: CGSize, hasAlpha: Bool) async throws -> NSImage {
        guard let imageURL = imageURL, let image = NSImage(contentsOf: imageURL) else {
            fatalError("Image does not exist!")
        }
        return try await image.resized(to: size, hasAlpha: hasAlpha)
    }
}

extension NSImage {
    func resizedV1(to size: CGSize) -> NSImage? {
        let result = NSImage(size: size)
        result.lockFocus()
        defer {
            result.unlockFocus()
        }
        if let context = NSGraphicsContext.current {
            context.imageInterpolation = .high
            draw(
                in: NSRect(origin: .zero, size: size),
                from: NSRect(origin: .zero, size: self.size),
                operation: .copy,
                fraction: 1
            )
            return result
        } else {
            return nil
        }
    }

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
}
