//
//  NSImage.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/6.
//

import AVKit

extension NSImage {
    func resized(to newSize: NSSize, hasAlpha: Bool = true) async throws -> NSImage {
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
        return newImage
    }

    func removedAlpha() async -> NSImage {
        guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            fatalError("No CGImage!")
        }
        let bitmapImageRep = NSBitmapImageRep(cgImage: cgImage)
        guard let newBitmapImageRep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(bitmapImageRep.size.width),
            pixelsHigh: Int(bitmapImageRep.size.height),
            bitsPerSample: bitmapImageRep.bitsPerSample,
            samplesPerPixel: bitmapImageRep.samplesPerPixel,
            hasAlpha: bitmapImageRep.hasAlpha,
            isPlanar: false,
            colorSpaceName: bitmapImageRep.colorSpaceName,
            bytesPerRow: bitmapImageRep.bytesPerRow,
            bitsPerPixel: bitmapImageRep.bitsPerPixel
        ) else {
            fatalError("Can not initialize NSBitmapImageRep!")
        }
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: newBitmapImageRep)
        let rect = NSRect(
            x: 0,
            y: 0,
            width: newBitmapImageRep.size.width,
            height: newBitmapImageRep.size.height
        )
        NSColor.white.drawSwatch(in: rect)
        rect.fill()
        draw(in: rect)
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: rect.size)
        newImage.addRepresentation(newBitmapImageRep)
        return newImage
    }
}

extension NSImage {
    var pngData: Data? {
        guard let data = tiffRepresentation,
            let imageRep = NSBitmapImageRep(data: data),
            let pngData = imageRep.representation(using: .png, properties: [:])
        else {
            return nil
        }
        return pngData
    }
}
