//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by 杜俊楠 on 2022/7/26.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    
//    @StateObject var document = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "defalut")
    
    var body: some Scene {
        /*
        WindowGroup {
            EmojiArtDocView(document: document)
                .environmentObject(paletteStore)
        }
        */
        
        DocumentGroup(newDocument: { EmojiArtDocument() }) { config in
            EmojiArtDocView(document: config.document)
                .environmentObject(paletteStore)
        }
        
    }
}
