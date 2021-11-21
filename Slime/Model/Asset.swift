//
//  Asset.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import AppKit
import Foundation

struct Asset: Identifiable {
    var size: CGFloat
    var image: NSImage

    var id: String {
        name
    }

    var name: String {
        let size = Int(size)
        return "\(size)x\(size)px"
    }

    var fileName: String {
        "\(Int(size)).png"
    }
}
