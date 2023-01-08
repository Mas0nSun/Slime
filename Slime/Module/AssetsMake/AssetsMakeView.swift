//
//  AssetsMakeView.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/7.
//

import SwiftUI

struct AssetsMakeView: View {
    @EnvironmentObject private var assetsMaker: AssetsMaker

    var body: some View {
        HStack(spacing: 0) {
            AssetsSettingView()
            AssetsPreviewView()
                .frame(minWidth: 500)
        }
        .environmentObject(assetsMaker)
        .onAppear {
            Task {
                await assetsMaker.loadAssetContents()
            }
        }
    }
}

struct AssetsMakeView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsMakeView()
    }
}
