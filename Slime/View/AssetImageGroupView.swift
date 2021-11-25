//
//  AssetImageGroupView.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/25.
//

import SwiftUI

struct AssetImageGroupView: View {
    @EnvironmentObject private var assetsStore: AssetsStore

    var group: AssetImageGroup

    var body: some View {
        VStack {
            HStack {
                ForEach(group.images, id: \.self) { image in
                    imageView(image)
                }
            }
            if let image = group.images.first {
                VStack {
                    Text(image.idiom)
                    Text(image.ptSize.width.string + "pt")
                }
                .font(.subheadline)
            }
        }
    }

    @ViewBuilder
    private func imageView(_ image: AssetContent.Image) -> some View {
        let ptSize = min(max(max(image.ptSize.width, image.ptSize.height), 60), 200)
        if let nsImage = assetsStore.assets[image] {
            Image(nsImage: nsImage)
                .resizable()
                .frame(width: ptSize, height: ptSize)
        } else {
            Text("\(image.pxSize.width.string)x\(image.pxSize.height.string)px")
                .font(.footnote)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.3)
                .frame(width: ptSize, height: ptSize)
                .dashBorderStyle(cornerRadius: ptSize > 100 ? 8 : 4)
        }
    }
}
