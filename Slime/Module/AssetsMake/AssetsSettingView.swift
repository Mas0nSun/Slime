//
//  AssetsSettingView.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/19.
//

import SwiftUI

struct AssetsSettingView: View {
    @EnvironmentObject private var assetsStore: AssetsMaker
    @State private var isTargeted = false

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            previewView
            SystemPicker(selections: $assetsStore.systemTypes)
            HStack {
                alphaToggle
                generateButton
            }
        }
        .padding()
        .onDrop(of: [.dropURLType], isTargeted: $isTargeted) { providers, _ in
            guard let provider = providers.first else {
                return false
            }
            Task {
                do {
                    let urlData = try await provider.loadItem(
                        forTypeIdentifier: .dropURLType,
                        options: nil
                    )
                    guard let urlData = urlData as? Data else {
                        return
                    }
                    self.assetsStore.imageURL = NSURL(
                        absoluteURLWithDataRepresentation: urlData, relativeTo: nil
                    ) as URL
                } catch {
                    print(error)
                }
            }
            return true
        }
    }

    @ViewBuilder
    private var previewView: some View {
        if let imageURL = assetsStore.imageURL {
            if #available(macOS 12.0, *) {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
            } else {
                Image(nsImage: NSImage(contentsOf: imageURL)!)
                    .frame(width: 200, height: 200)
            }
        } else {
            ZStack {
                Image(systemName: "square.and.arrow.down")
                    .font(.largeTitle)
                VStack(spacing: 4) {
                    Spacer()
                    Text("Drop icon asset here.")
                    Text("(1024 * 1024 preferred)")
                        .font(.subheadline.bold())
                }
                .padding(.bottom)
            }
            .foregroundColor(.secondary)
            .frame(width: 200, height: 200)
            .dashBorderStyle()
        }
    }

    private var alphaToggle: some View {
        Toggle("Alpha", isOn: $assetsStore.hasAlpha)
    }

    private var generateButton: some View {
        let isDisable = assetsStore.imageURL == nil || assetsStore.systemTypes.isEmpty
        return Button("Generate") {
            Task {
                try await assetsStore.generateAssets()
            }
        }
        .disabled(isDisable)
        .keyboardShortcut(.defaultAction)
    }
}

struct AssetsSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsSettingView()
    }
}
