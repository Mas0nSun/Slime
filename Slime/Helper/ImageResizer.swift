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

    func generateImages(for sizes: [CGSize]) -> [NSImage] {
        guard let imageURL = imageURL else {
            return []
        }
        let image = NSImage(contentsOf: imageURL)
        return sizes.compactMap {
            image?.resized(to: $0)
        }
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

    func resized(to newSize: NSSize) -> NSImage? {
        guard isValid else { return nil }
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
            return nil
        }
        bitmapImageRep.size = newSize
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapImageRep)

        draw(
            in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height),
            from: NSZeroRect,
            operation: .copy,
            fraction: 1.0
        )
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: newSize)
        newImage.addRepresentation(bitmapImageRep)
        return newImage
    }
}
