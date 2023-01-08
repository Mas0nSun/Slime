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
        // TODO: change to 13.0
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

    private var contentView: some View {
        VStack {
            if alphaRemover.imageURLs.isEmpty {
                VStack {
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
                                case let .success(image):
                                    Text("\(image.hasAlpha == true ? "true" : "false")")
                                        .foregroundColor(image.hasAlpha ? .red : .green)
                                case .failure:
                                    HStack {
                                        Text("Error")
                                        Image(systemName: "xmark.octagon")
                                    }
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
