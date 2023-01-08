//
//  AssetsPreviewView.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import SwiftUI
import UniformTypeIdentifiers

struct AssetsPreviewView: View {
    @EnvironmentObject private var assetsMaker: AssetsMaker

    var body: some View {
        List {
            ForEach(assetsMaker.systemTypes) { system in
                makeSectionView(system: system)
            }
        }
        .fileExporter(
            isPresented: $assetsMaker.isShowingExporter,
            documents: assetsMaker.documents,
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

    @ViewBuilder
    private func makeSectionView(system: SystemType) -> some View {
        if let assetContent = assetsMaker.assetContents
            .first(where: { $0.system == system })
        {
            Section {
                let columns = Array(repeating: GridItem(.flexible(), alignment: .bottom), count: 2)
                LazyVGrid(columns: columns) {
                    ForEach(groupAssetsImages(assetContent.content.images), id: \.self) { group in
                        AssetImageGroupView(group: group)
                            .environmentObject(assetsMaker)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding()
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
            .sorted {
                if $0.ptSize.width != $1.ptSize.width {
                    return $0.ptSize.width < $1.ptSize.width
                } else {
                    return ($0.images.first?.idiom ?? "") > ($1.images.first?.idiom ?? "")
                }
            }
    }
}

struct AssetsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsPreviewView()
    }
}
