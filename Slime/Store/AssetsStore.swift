//
//  AssetsStore.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import AppKit
import Foundation

class AssetsStore: ObservableObject {
    @Published var imageURL: URL? {
        didSet {
            cleanAssets()
        }
    }

    @Published var systemTypes: [SystemType] = []
    @Published private(set) var assetContents: [AssetContent] = []
    @Published private(set) var assets: [AssetContent.Image: NSImage] = [:]

    private let imageResizer = ImageResizer()

    func loadAssetContents() async {
        do {
            assetContents = try await AssetContent.loadAssetContents()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func generateAssets() async throws {
        imageResizer.imageURL = imageURL
        for systemType in systemTypes {
            guard let assetContent = assetContents
                .first(where: { $0.system == systemType })
            else {
                continue
            }
            for image in assetContent.content.images {
                let nsImage = try await imageResizer.generateImage(for: image.sizeValue)
                assets[image] = nsImage
            }
        }
    }

    private func cleanAssets() {
        assets = [:]
    }
}
