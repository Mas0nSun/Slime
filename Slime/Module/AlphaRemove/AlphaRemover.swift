//
//  AlphaRemover.swift
//  Slime
//
//  Created by Mason Sun on 2023/1/7.
//

import AppKit

final class AlphaRemover: ObservableObject {
    static let shared = AlphaRemover()
    @Published private(set) var images: [URL: ImageResult] = [:]
    @Published private(set) var imageURLs: [URL] = []
    @Published var isShowingExporter = false

    private init() { }

    func remove(imageURL: URL) {
        guard let index = imageURLs.firstIndex(of: imageURL) else {
            return
        }
        imageURLs.remove(at: index)
    }

    func processImages(for urls: [URL]) async {
        await MainActor.run {
            self.imageURLs = urls
        }
        urls.enumerated().forEach { index, url in
            Task {
                guard let image = NSImage(contentsOf: url) else {
                    await MainActor.run {
                        self.images[url] = .failure
                    }
                    return
                }
                let imageWithoutAlpha = await image.removedAlpha()
                await MainActor.run {
                    self.images[url] = .success(imageWithoutAlpha)
                }
            }
        }
    }

    func processImages(for providers: [NSItemProvider]) async throws {
        let urlAndData = try await withThrowingTaskGroup(of: (URL, Data).self) { taskGroup -> [(URL, Data)] in
            for provider in providers {
                taskGroup.addTask {
                    let data = try await provider.loadItem(
                        forTypeIdentifier: .dropURLType,
                        options: nil
                    ) as! Data
                    let url = NSURL(
                        absoluteURLWithDataRepresentation: data,
                        relativeTo: nil
                    ) as URL
                    return (url, data)
                }
            }
            return try await taskGroup.reduce(into: []) { $0.append($1) }
        }
        await processImages(for: urlAndData.map { $0.0 })
    }

    @objc func exportAssets() {
        isShowingExporter = true
    }

    // TODO: Updated it when exported data changes
    var canExport: Bool {
        !images.values.isEmpty
    }

    var documents: [ImagesDocument] {
        [
            ImagesDocument(
                images: imageURLs.compactMap { url -> (String, NSImage)? in
                    guard let image = images[url] else {
                        return nil
                    }
                    if case let .success(image) = image {
                        return (url.lastPathComponent, image)
                    } else {
                        return nil
                    }
                }
            )
        ]
    }
}

extension NSItemProvider: @unchecked Sendable { }

extension AlphaRemover {
    enum ImageResult {
        case success(NSImage)
        case failure
    }
}
