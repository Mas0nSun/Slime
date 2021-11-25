//
//  SlimeApp.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/19.
//

import SwiftUI

@main
struct SlimeApp: App {
    @StateObject private var assetsStore = AssetsStore()

    var body: some Scene {
        WindowGroup {
            HStack(spacing: 0) {
                ContentView()
                    .environmentObject(assetsStore)
                AssetsPreviewView()
                    .frame(minWidth: 300)
                    .environmentObject(assetsStore)
            }
            .task {
                await assetsStore.loadAssetContents()
            }
        }
    }
}
