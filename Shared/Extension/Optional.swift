//
//  Optional.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import Foundation
import SwiftUI

func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
