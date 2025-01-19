//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Dhruv Chhatbar on 28/12/24.
//

import SwiftUI

@main
struct EmojiArtApp: App {
//    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Main")
    var body: some Scene {
        DocumentGroup(newDocument: {EmojiArtDocument()}) { config in
            EmojiArtDocumentView(document: config.document)
                .environmentObject(paletteStore)
        }
    }
}
