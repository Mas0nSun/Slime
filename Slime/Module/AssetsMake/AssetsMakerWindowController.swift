//
//  AssetsMakerWindowController.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/8.
//

import AppKit

class AssetsMakerWindowController: NSWindowController {
    private var toolBar: NSToolbar!

    override init(window: NSWindow?) {
        super.init(window: window)
        toolBar = NSToolbar(identifier: "Export")
        toolBar.displayMode = .iconOnly
        toolBar.delegate = self
        self.window?.toolbar = toolBar
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func exportAssets() {
        AssetsMaker.shared.exportAssets()
    }
}

extension AssetsMakerWindowController: NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
        let identifiers: [NSToolbarItem.Identifier] = [.exportAssets]
        return identifiers
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarDefaultItemIdentifiers(toolbar)
    }

    func toolbar(
        _: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar _: Bool
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
