//
//  AlphaRemoverWindowController.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/8.
//

import AppKit

// TODO: This controller is same to AssetsMakerWindowController
class AlphaRemoverWindowController: NSWindowController {
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
        AlphaRemover.shared.exportAssets()
    }
}

extension AlphaRemoverWindowController: NSToolbarDelegate {
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

extension AlphaRemoverWindowController: NSToolbarItemValidation {
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        guard item.itemIdentifier == .exportAssets else {
            return false
        }
        return AlphaRemover.shared.canExport
    }
}
