//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by 杜俊楠 on 2022/7/29.
//

import SwiftUI

struct PaletteChooser: View {
    var emojiFondSize: CGFloat = 40
    var emojiFond: Font { .system(size:emojiFondSize) }
    
    @EnvironmentObject var store: PaletteStore
    
    @SceneStorage("PaletteChooser") private var chosenPaletteIndex = 0
    
    var body: some View {
        HStack {
            paletteControlButten
            body(for: store.palette(at: chosenPaletteIndex))
        }
        .clipped()
    }
    
    var paletteControlButten: some View {
        Button {
            withAnimation {
                chosenPaletteIndex = (chosenPaletteIndex + 1) % store.palettes.count
            }
        } label: {
            Image(systemName: "paintpalette")
        }
        .font(emojiFond)
        .contextMenu { contextMune }
    }
    
    @ViewBuilder
    var contextMune: some View {
        AnimatedActionButton(title: "edit", systemImage: "pencil") {
//            editing = true
            paletteToEdit = store.palette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "new", systemImage: "plus") {
            store.insertPalette(named: "new", emojis: "", at: chosenPaletteIndex)
//            editing = true
            paletteToEdit = store.palette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "delete", systemImage: "minus.circle") {
            chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "manager", systemImage: "slider.vertical.3") {
            manager = true
        }
        gotoMenu
        
    }
    
    var gotoMenu: some View {
        Menu {
            ForEach(store.palettes) { palette in
                AnimatedActionButton(title: palette.name) {
                    if let index = store.palettes.index(matching: palette) {
                        chosenPaletteIndex = index
                    
                    }
                }
            }
        } label: {
            Label("go to", systemImage: "text.insert")
        }
        
    }
    
    
    func body(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollEmojisView(emojis: palette.emojis)
                .font(emojiFond)
        }
        .id(palette.id)
        .transition(rollTransition)
//        .popover(isPresented: $editing) {
//            PaletteEditor(palette: $store.palettes[chosenPaletteIndex])
//        }
        .popover(item: $paletteToEdit) { palette in
            PaletteEditor(palette: $store.palettes[palette])
                .wrappedInNavgationViewToMakeDismissable {
                    paletteToEdit = nil
                }
        }
        .sheet(isPresented: $manager) {
            PaletteManager()
        }
        
    }
    
//    @State private var editing = false
    @State private var manager: Bool = false
    @State private var paletteToEdit: Palette?
    
    
    var rollTransition: AnyTransition {
        AnyTransition.asymmetric(insertion: .offset(x: 0, y: emojiFondSize), removal: .offset(x: 0, y: -emojiFondSize))
    }
    
    
//    let testemojis = "☀️🌤⛅️🚙🚗🚘🚕🚖🏎🚚🛻🏈⚾️🏀⚽️"

    struct ScrollEmojisView: View {
        let emojis:String
        var body: some View {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(emojis.map { String($0) }, id: \.self ) { emoji in
                        Text(emoji)
                            .onDrag {
                                NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
        }
    }
    
    
    
    
    
}










//struct PaletteChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        PaletteChooser()
//    }
//}
