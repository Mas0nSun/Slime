//
//  AssetsDocument.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import SwiftUI
import UniformTypeIdentifiers

private let appIconSetFolderName = "AppIcon.appiconset"
private let contentsJSONFileName = "Contents.json"

struct AssetsDocument: FileDocument {
    private let assetContents: [AssetContent]
    private let assets: [AssetContent.Image: NSImage]

    static var readableContentTypes: [UTType] {
        [.folder, .png]
    }

    init(assetContents: [AssetContent], assets: [AssetContent.Image: NSImage]) {
        self.assetContents = assetContents
        self.assets = assets
    }

    init(configuration _: ReadConfiguration) throws {
        assetContents = []
        assets = [:]
    }

    func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
        var files: [String: FileWrapper] = [:]
        assetContents.forEach { assetContent in
            var fileWrappers: [String: FileWrapper] = [:]
            let images = assetContent.content.images
            images.forEach { image in
                if let nsImage = assets[image],
                   let pngData = nsImage.pngData
                {
                    // Add png to folder
                    fileWrappers[image.filename] = FileWrapper(regularFileWithContents: pngData)
                }
            }
            // Add `Contents.json` to folder
            let contentsJSONData = assetContent.content.jsonData
            fileWrappers[contentsJSONFileName] = FileWrapper(regularFileWithContents: contentsJSONData)
            // Wrap folder in `AppIcon.appiconset`
            let appIconFolder = FileWrapper(
                directoryWithFileWrappers: [
                    appIconSetFolderName: FileWrapper(directoryWithFileWrappers: fileWrappers),
                ]
            )
            // Wrap `AppIcon.appiconset` in system folder
            files[assetContent.system.rawValue] = appIconFolder
        }
        return FileWrapper(directoryWithFileWrappers: files)
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
