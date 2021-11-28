//
//  SystemType.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import Foundation

enum SystemType: String, CaseIterable, Identifiable, Codable {
    case iOS
    case watchOS
    case macOS
//    case tvOS

    var id: String {
        rawValue
    }
}
