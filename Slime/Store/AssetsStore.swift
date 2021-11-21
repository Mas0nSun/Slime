//
//  AssetsStore.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import Foundation

class AssetsStore: ObservableObject {
    @Published var imageURL: URL? {
        didSet {
            cleanAssets()
        }
    }

    @Published var systemTypes: [SystemType] = []
    @Published private(set) var systemTypeToAssets: [SystemType: [Asset]] = [:]

    private let imageResizer = ImageResizer()

    func generateAssets() {
        imageResizer.imageURL = imageURL
        systemTypes.forEach { systemType in
            let assets = zip(systemType.assetSizes, imageResizer.generateImages(
                for: systemType.assetSizes.map { CGSize(width: $0, height: $0) }
            )).map {
                Asset(size: $0, image: $1)
            }
            systemTypeToAssets[systemType] = assets
        }
    }

    private func cleanAssets() {
        systemTypeToAssets = [:]
    }
}
