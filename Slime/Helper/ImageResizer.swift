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
