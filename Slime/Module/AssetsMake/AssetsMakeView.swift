//
//  AssetsMakeView.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/7.
//

import SwiftUI

struct AssetsMakeView: View {
    var body: some View {
        HStack(spacing: 0) {
            ContentView()
            AssetsPreviewView()
                .frame(minWidth: 500)
        }
        .onAppear {
            Task {
                await AssetsStore.shared.loadAssetContents()
            }
        }
    }
}

struct AssetsMakeView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsMakeView()
    }
}
