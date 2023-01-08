//
//  AssetsMaker.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import AppKit
import Foundation
import Combine

@MainActor
final class AssetsMaker: ObservableObject {
    static let shared = AssetsMaker()
    @Published var imageURL: URL? {
        didSet {
            cleanAssets()
        }
    }

    @Published var systemTypes: [SystemType] = []
    @Published var hasAlpha: Bool = true
    @Published private(set) var assetContents: [AssetContent] = []
    @Published private(set) var assets: [AssetContent.Image: NSImage] = [:]
    @Published var isShowingExporter: Bool = false
    private let imageResizer = ImageResizer()
    private var disposeBag: Set<AnyCancellable> = []

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

    // MARK: Export

    @objc func exportAssets() {
        isShowingExporter = true
    }

    // TODO: Updated it when exported data changes
    var canExport: Bool {
        !assets.isEmpty
    }

    var documents: [AssetsDocument] {
        [
            AssetsDocument(
                assetContents: assetContents.filter {
                    systemTypes.contains($0.system)
                },
                assets: assets
            ),
        ]
    }
}
