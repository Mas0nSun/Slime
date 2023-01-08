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
                .onDrop(of: ["public.file-url"], isTargeted: $isTargeted) { providers, _ in
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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            VStack {
                ForEach(alphaRemover.imageURLs, id: \.self) { url in
                    HStack {
                        Text(url.lastPathComponent)
                        if let imageResult = alphaRemover.images[url] {
                            switch imageResult {
                            case let .success(image):
                                Image(nsImage: image)
                                    .resizable()
                                    .frame(width: 40, height: 80)
                                Text("\(image.size.width)")
                                Text("\(image.hasAlpha == true ? "true" : "false")")
                                    .foregroundColor(image.hasAlpha ? .red : .green)
                            case .failure:
                                Text("Failed")
                            }
                        } else {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    }
                }
            }
        }
        .frame(width: 400, height: 200)
    }
}

struct AlphaRemoveView_Previews: PreviewProvider {
    static var previews: some View {
        AlphaRemoveView()
    }
}
