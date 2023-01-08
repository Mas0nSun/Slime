//
//  AssetsStore.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import AppKit
import Foundation

@MainActor
class AssetsStore: ObservableObject {
    static let shared = AssetsStore()
    @Published var imageURL: URL? {
        didSet {
            cleanAssets()
        }
    }

    @Published var systemTypes: [SystemType] = []
    @Published var hasAlpha: Bool = true
    @Published private(set) var assetContents: [AssetContent] = []
    @Published private(set) var assets: [AssetContent.Image: NSImage] = [:]

    private let imageResizer = ImageResizer()

    private init() {}

    func loadAssetContents() async {
        do {
            let assetContents = try await AssetContent.loadAssetContents()
            self.assetContents = assetContents
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
                let nsImage = try await imageResizer.generateImage(
                    for: image.pxSize,
                    hasAlpha: hasAlpha
                )
                assets[image] = nsImage
            }
        }
    }

    private func cleanAssets() {
        assets = [:]
    }
}
