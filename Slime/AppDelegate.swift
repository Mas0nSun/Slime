//
//  AppDelegate.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/7.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var windowControllers: [Module: NSWindowController] = [:]

    override init() {
        super.init()
        _ = AssetsStore.shared
    }

    func applicationDidFinishLaunching(_: Notification) {
        setUpStatusItem()
        setUpMenu()
    }

    private func setUpStatusItem() {
        statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(
                systemSymbolName: "circle",
                accessibilityDescription: "Slime"
            )
        }
    }

    private func setUpMenu() {
        let menu = NSMenu()
        Module.allCases.forEach { module in
            let menuItem = NSMenuItem()
            menuItem.title = module.title
            menuItem.image = NSImage(
                systemSymbolName: module.symbol,
                accessibilityDescription: module.title
            )
            menuItem.representedObject = module
            menuItem.action = #selector(onMenuItemSelected)
            menu.addItem(menuItem)
        }
        menu.addItem(NSMenuItem.separator())
        // About
        let aboutItem = NSMenuItem(
            title: "About",
            action: #selector(openAbout), keyEquivalent: ""
        )
        menu.addItem(aboutItem)
        // About
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quitApp), keyEquivalent: "Q"
        )
        menu.addItem(quitItem)
        statusItem.menu = menu
    }

    @objc private func onMenuItemSelected(_ sender: NSMenuItem) {
        let module = sender.representedObject as! Module
        var windowController = windowControllers[module]
        if windowController == nil {
            let viewController = NSHostingController(rootView: contentView(module: module))
            let window = NSWindow(contentViewController: viewController)
            windowController = NSWindowController(window: window)
            windowControllers[module] = windowController
        }
        NSApp.activate(ignoringOtherApps: true)
        windowController?.showWindow(self)
    }

    @objc private func openAbout(_ sender: Any) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(sender)
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    @ViewBuilder
    private func contentView(module: Module) -> some View {
        switch module {
        case .assetsMake:
            HStack(spacing: 0) {
                ContentView()
                AssetsPreviewView()
                    .frame(minWidth: 500)
            }
            .environmentObject(AssetsStore.shared)
            .onAppear {
                Task {
                    await AssetsStore.shared.loadAssetContents()
                }
            }
        case .alphaRemove:
            Text("No Alpha")
        }
    }
}
