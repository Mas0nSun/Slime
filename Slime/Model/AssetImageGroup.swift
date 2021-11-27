//
//  AssetImageGroup.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/25.
//

import Foundation

struct AssetImageGroup: Hashable {
    var ptSize: CGSize
    var images: [AssetContent.Image]
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
