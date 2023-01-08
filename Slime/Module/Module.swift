//
//  Module.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/6.
//

import Foundation
import SwiftUI

enum Module: String, CaseIterable {
    // Make icon assets
    case assetsMaker
    // Remove alpha for images
    case alphaRemover

    var title: String {
        switch self {
        case .assetsMaker:
            return "Assets Maker"
        case .alphaRemover:
            return "Alpha Remover"
        }
    }

    var symbol: String {
        switch self {
        case .assetsMaker:
            return "square.stack.3d.up.fill"
        case .alphaRemover:
            return "eraser.fill"
        }
    }
}
