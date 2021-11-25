//
//  View.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/25.
//

import SwiftUI

extension View {
    func dashBorderStyle(cornerRadius: CGFloat = 8) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    .secondary,
                    style: StrokeStyle(
                        lineWidth: 1,
                        lineCap: .round,
                        lineJoin: .miter,
                        miterLimit: 0,
                        dash: [4],
                        dashPhase: 0
                    )
                )
        )
    }
}
