//
//  ImagesDocument.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/8.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImagesDocument: FileDocument {
    let images: [(String, NSImage)]

    static var readableContentTypes: [UTType] {
        [.folder, .png]
    }

    init(images: [(String, NSImage)]) {
        self.images = images
    }

    init(configuration _: ReadConfiguration) throws {
        images = []
    }

    func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
        var files: [String: FileWrapper] = [:]
        images.forEach { name, image in
            if let pngData = image.pngData {
                files[name] = FileWrapper(regularFileWithContents: pngData)
            }
        }
        return FileWrapper(directoryWithFileWrappers: files)
    }
}
