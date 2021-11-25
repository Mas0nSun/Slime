//
//  CGFloat.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/25.
//

import Foundation

extension CGFloat {
    var string: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter.string(from: self as NSNumber) ?? ""
    }
}
