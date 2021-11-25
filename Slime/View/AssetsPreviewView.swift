//
//  AssetsPreviewView.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import SwiftUI
import UniformTypeIdentifiers

struct AssetsPreviewView: View {
    @EnvironmentObject private var assetsStore: AssetsStore
    @State private var isShowingExporter: Bool = false

    var body: some View {
        List {
            ForEach(assetsStore.systemTypes) { system in
                makeSectionView(system: system)
            }
        }
        .toolbar {
            exportButton
        }
        .fileExporter(
            isPresented: $isShowingExporter,
            documents: documents,
            contentType: .folder
        ) { result in
            switch result {
            case let .success(urls):
                print(urls)
            case let .failure(error):
                print(error)
            }
        }
    }

    private var documents: [AssetsDocument] {
        [AssetsDocument(assetContents: assetsStore.assetContents, assets: assetsStore.assets)]
    }

    private var exportButton: some View {
        Button {
            isShowingExporter.toggle()
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
        .disabled(assetsStore.assets.isEmpty)
    }

    @ViewBuilder
    private func makeSectionView(system: SystemType) -> some View {
        if let assetContent = assetsStore.assetContents
            .first(where: { $0.system == system })
        {
            Section {
                LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                    ForEach(groupAssetsImages(assetContent.content.images), id: \.self) { group in
                        AssetImageGroupView(group: group)
                            .environmentObject(assetsStore)
                            .padding()
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            } header: {
                Text(system.rawValue)
                    .font(.title3)
            }
        }
    }

    private func groupAssetsImages(_ images: [AssetContent.Image]) -> [AssetImageGroup] {
        Dictionary(grouping: images) { $0.size + $0.idiom }
            .values
            .compactMap { images -> AssetImageGroup? in
                guard let ptSize = images.first?.ptSize else { return nil }
                return AssetImageGroup(ptSize: ptSize, images: images)
            }
            .sorted { $0.ptSize.width < $1.ptSize.width }
    }

    private func makeImageItem(image: AssetContent.Image) -> some View {
        VStack {
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
            Text(image.filename)
                .font(.subheadline)
        }
    }
}

struct AssetsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsPreviewView()
    }
}
