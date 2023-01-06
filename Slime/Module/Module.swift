//
//  Module.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/6.
//

import Foundation

enum Module: String, CaseIterable {
    // Make icon assets
    case assetsMake
    // Remove alpha for images
    case alphaRemove

    var title: String {
        switch self {
        case .assetsMake:
            return "Assets Maker"
        case .alphaRemove:
            return "No Alpha"
        }
    }

    var symbol: String {
        switch self {
        case .assetsMake:
            return "square.stack.3d.up.fill"
        case .alphaRemove:
            return "eraser.fill"
        }
    }
}
