//
//  SystemType.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import Foundation

enum SystemType: String, CaseIterable, Identifiable {
    case iOS
    case watchOS
    case macOS
//    case tvOS

    var id: String {
        rawValue
    }

    var assetSizes: [CGFloat] {
        switch self {
        case .iOS:
            return [20, 29, 40, 58, 60, 76, 80, 87, 120, 152, 167, 180, 1024]
        case .watchOS:
            return [48, 55, 58, 66, 80, 87, 88, 92, 100, 102, 172, 196, 216, 234, 1024]
        case .macOS:
            return [16, 32, 64, 128, 256, 512, 1024]
//        case .tvOS:
//            return [30, 60]
        }
    }
}
