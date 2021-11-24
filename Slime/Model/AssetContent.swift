//
//  AssetContent.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/24.
//

import Foundation

struct AssetContent: Codable {
    var system: SystemType
    var content: Content
}

extension AssetContent {
    struct Content: Codable {
        var info: Info
        var images: [Image]
    }

    struct Info: Codable {
        var author: String
        var version: Int
    }

    struct Image: Codable, Hashable {
        var filename: String
        var idiom: String
        var scale: String
        var size: String

        var sizeValue: CGSize {
            let widthAndHeight = size.split(separator: "x")
                .compactMap { CGFloat(Double($0) ?? 0) }
            return CGSize(
                width: widthAndHeight.first!,
                height: widthAndHeight.last!
            )
        }

        var scaleValue: Int {
            scale.split(separator: "x")
                .compactMap { Int($0) }
                .first!
        }
    }
}

extension AssetContent {
    @MainActor
    static func loadAssetContents() async throws -> [AssetContent] {
        try await withCheckedThrowingContinuation { continuation in
            guard let path = Bundle.main.path(forResource: "AssetContents", ofType: "json") else {
                continuation.resume(returning: [])
                return
            }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let result = try JSONDecoder().decode([AssetContent].self, from: data)
                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
