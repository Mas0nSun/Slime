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

        var jsonData: Data {
            do {
                return try JSONEncoder().encode(self)
            } catch {
                fatalError("Can not encode AssetContent!")
            }
        }
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
        var role: String?
        var subtype: String?

        var ptSize: CGSize {
            let widthAndHeight = size.split(separator: "x")
                .compactMap { CGFloat(Double($0) ?? 0) }
            return CGSize(
                width: widthAndHeight.first!,
                height: widthAndHeight.last!
            )
        }

        var pxSize: CGSize {
            CGSize(
                width: ptSize.width * scaleValue,
                height: ptSize.height * scaleValue
            )
        }

        var scaleValue: CGFloat {
            scale.split(separator: "x")
                .compactMap { CGFloat(Double($0) ?? 1) }
                .first!
        }

        var idiomName: String {
            switch idiom.lowercased() {
            case "iphone":
                return "iPhone"
            case "ipad":
                return "iPad"
            case "watch":
                return "iWatch"
            case "mac":
                return "iMac"
            default:
                return ""
            }
        }

        var idiomRole: String {
            if size == "20x20" {
                return "Notification"
            } else if size == "29x29" {
                return "Settings"
            } else if size == "40x40" {
                return "Spotlight"
            } else if size == "1024x1024" {
                return "App Store"
            } else {
                return "App"
            }
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
