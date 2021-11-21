//
//  AssetsDocument.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import SwiftUI
import UniformTypeIdentifiers

struct AssetsDocument: FileDocument {
    let assets: [SystemType: [Asset]]

    static var readableContentTypes: [UTType] {
        [.folder, .png]
    }

    init(assets: [SystemType: [Asset]]) {
        self.assets = assets
    }

    init(configuration _: ReadConfiguration) throws {
        assets = [:]
    }

    func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
        var files: [String: FileWrapper] = [:]
        SystemType.allCases.forEach { systemType in
            guard let assets = assets[systemType] else { return }
            var fileWrappers: [String: FileWrapper] = [:]
            assets.forEach {
                guard let pngData = $0.image.pngData else {
                    return
                }
                fileWrappers[$0.fileName] = FileWrapper(regularFileWithContents: pngData)
            }
            files[systemType.rawValue] = FileWrapper(directoryWithFileWrappers: fileWrappers)
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
