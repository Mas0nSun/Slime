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
    private let assetsMaker = AssetsMaker.shared
    private let alphaRemover = AlphaRemover.shared

    override init() {
        super.init()
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
            let viewController = NSHostingController(rootView: makeContentView(module: module))
            viewController.title = module.title
            let window = NSWindow(contentViewController: viewController)
            windowController = makeWindowController(module: module, window: window)
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

    private func makeWindowController(
        module: Module,
        window: NSWindow
    ) -> NSWindowController {
        switch module {
        case .assetsMaker:
            return AssetsMakerWindowController(window: window)
        case .alphaRemover:
            return NSWindowController(window: window)
        }
    }

    @ViewBuilder
    private func makeContentView(module: Module) -> some View {
        switch module {
        case .assetsMaker:
            AssetsMakeView()
                .environmentObject(assetsMaker)
        case .alphaRemover:
            AlphaRemoveView()
                .environmentObject(alphaRemover)
        }
    }
}

class AssetsMakerWindowController: NSWindowController {
    private var toolBar: NSToolbar!

    override init(window: NSWindow?) {
        super.init(window: window)
        toolBar = NSToolbar(identifier: "Export")
        toolBar.displayMode = .iconOnly
        toolBar.delegate = self
        self.window?.toolbar = toolBar
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func exportAssets() {
        AssetsMaker.shared.exportAssets()
    }
}

extension AssetsMakerWindowController: NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        let identifiers: [NSToolbarItem.Identifier] = [.exportAssets]
        return identifiers
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarDefaultItemIdentifiers(toolbar)
    }

    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        var toolbarItem: NSToolbarItem?
        switch itemIdentifier {
        case .exportAssets:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.image = NSImage(
                systemSymbolName: "square.and.pencil",
                accessibilityDescription: "Export Assets"
            )
            item.label = "Export Assets"
            item.action = #selector(exportAssets)
            item.isEnabled = true
            toolbarItem = item
        default:
            toolbarItem = nil
        }
        return toolbarItem
    }
}

extension AssetsMakerWindowController: NSToolbarItemValidation {
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        guard item.itemIdentifier == .exportAssets else {
            return false
        }
        return AssetsMaker.shared.canExport
    }
}

extension NSToolbarItem.Identifier {
    static let exportAssets = NSToolbarItem.Identifier("export.assets")
}
