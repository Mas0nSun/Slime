//
//  ContentView.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var assetsStore: AssetsStore
    @State private var isTargeted = false

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            previewView
            SystemPicker(selections: $assetsStore.systemTypes)
            generateButton
        }
        .padding()
        .onDrop(of: ["public.file-url"], isTargeted: $isTargeted) { providers, _ in
            guard let provider = providers.first else {
                return false
            }
            Task {
                do {
                    let urlData = try await provider.loadItem(
                        forTypeIdentifier: "public.file-url",
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
            AsyncImage(url: imageURL) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
        } else {
            ZStack {
                Image(systemName: "square.and.arrow.down")
                    .font(.largeTitle)
                VStack {
                    Spacer()
                    Text("Drop icon asset here 👆\n(*1024 * 1024* preffered)")
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.bottom)
            }
            .foregroundColor(.secondary)
            .frame(width: 200, height: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        .secondary,
                        style: StrokeStyle(
                            lineWidth: 1,
                            lineCap: .round,
                            lineJoin: .miter,
                            miterLimit: 0,
                            dash: [4],
                            dashPhase: 0
                        )
                    )
            )
        }
    }

    private var generateButton: some View {
        let isDisable = assetsStore.imageURL == nil || assetsStore.systemTypes.isEmpty
        return Button("Generate") {
            assetsStore.generateAssets()
        }
        .disabled(isDisable)
        .keyboardShortcut(.defaultAction)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
