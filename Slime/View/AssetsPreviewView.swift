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
            ForEach(SystemType.allCases) { systemType in
                if let assets = assetsStore.systemTypeToAssets[systemType] {
                    Section {
                        ScrollView(.horizontal) {
                            HStack(alignment: .bottom, spacing: 32) {
                                ForEach(assets) { asset in
                                    makeRow(asset: asset)
                                }
                            }
                            .padding()
                        }
                    } header: {
                        Text(systemType.rawValue)
                            .font(.title3)
                    }
                }
            }
        }
        .toolbar {
            Button {
                isShowingExporter.toggle()
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .disabled(assetsStore.systemTypeToAssets.isEmpty)
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
        [AssetsDocument(assets: assetsStore.systemTypeToAssets)]
    }

    private func makeRow(asset: Asset) -> some View {
        VStack {
            let size = min(asset.size, 200)
            Image(nsImage: asset.image)
                .resizable()
                .frame(width: size, height: size)
            Text(asset.name)
        }
    }
}

struct AssetsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsPreviewView()
    }
}
