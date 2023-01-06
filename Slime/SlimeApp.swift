//
//  SlimeApp.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/19.
//

import SwiftUI

@main
struct SlimeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
    }
}
