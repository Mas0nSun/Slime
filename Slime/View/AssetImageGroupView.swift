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
            HStack(alignment: .bottom) {
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

    private func imageView(_ image: AssetContent.Image) -> some View {
        let minSize: CGFloat = 60
        let maxSize: CGFloat = 200
        let previewScale: CGFloat = 0.7
        let pxSize = max(image.pxSize.width * previewScale, image.pxSize.height * previewScale)
        let previewSize = min(max(minSize, pxSize), maxSize)
        return VStack {
            if let nsImage = assetsStore.assets[image] {
                Image(nsImage: nsImage)
                    .resizable()
                    .frame(width: min(pxSize, maxSize), height: min(pxSize, maxSize))
                    .frame(width: previewSize, height: previewSize, alignment: .bottom)
            } else {
                Text("\(image.pxSize.width.string)x\(image.pxSize.height.string)px")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .frame(width: previewSize, height: previewSize)
                    .dashBorderStyle(cornerRadius: pxSize > 100 ? 8 : 4)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            Text(image.scale)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
