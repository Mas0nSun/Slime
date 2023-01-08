//
//  AlphaRemoveView.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/7.
//

import SwiftUI

struct AlphaRemoveView: View {
    @EnvironmentObject private var alphaRemover: AlphaRemover
    @State private var isTargeted = false

    var body: some View {
        Group {
            if #available(macOS 13.0, *) {
                contentView
                    .dropDestination(for: URL.self) { items, location in
                        Task {
                            await alphaRemover.processImages(for: items)
                        }
                        return true
                    }
            } else {
                contentView
                    .onDrop(of: [.dropURLType], isTargeted: $isTargeted) { providers, _ in
                        Task {
                            do {
                                try await alphaRemover.processImages(for: providers)
                            } catch {
                                print(error)
                            }
                        }
                        return true
                    }
            }
        }
        .fileExporter(
            isPresented: $alphaRemover.isShowingExporter,
            documents: alphaRemover.documents,
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

    private var contentView: some View {
        VStack {
            if alphaRemover.imageURLs.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.largeTitle)
                    Text("Drop images here.")
                }
                .foregroundColor(.secondary)
                .frame(width: 200, height: 200)
                .dashBorderStyle()
            } else {
                List {
                    ForEach(alphaRemover.imageURLs, id: \.self) { url in
                        HStack(spacing: 0) {
                            Text(url.lastPathComponent)
                            Spacer(minLength: 4)
                            if let imageResult = alphaRemover.images[url] {
                                switch imageResult {
                                case .success:
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                case .failure:
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .onTapGesture {
                                            withAnimation {
                                                alphaRemover.remove(imageURL: url)
                                            }
                                        }
                                }
                            } else {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(minWidth: 300, minHeight: 300)
    }
}

struct AlphaRemoveView_Previews: PreviewProvider {
    static var previews: some View {
        AlphaRemoveView()
    }
}
