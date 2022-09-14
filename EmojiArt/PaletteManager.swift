//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by 杜俊楠 on 2022/8/12.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading) {
                            Text(palette.name)
//                                .font(editMode == .active ? Font.largeTitle : Font.caption)
                            Text(palette.emojis)
                        }
                        .gesture( editMode == .active ? tap : nil )
                    }
                }
                .onDelete { IndexSet in
                    store.palettes.remove(atOffsets: IndexSet)
                }
                .onMove { IndexSet, newOffset in
                    store.palettes.move(fromOffsets: IndexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("调色板管理器")
            .navigationBarTitleDisplayMode(.inline)
            .dismissable({
                presentationMode.wrappedValue.dismiss()
            })
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
             }
            .environment(\.editMode, $editMode)
        }
    }
    
    
    var tap: some Gesture {
        TapGesture().onEnded{
            print("did tap gesture")
        }
    }
    
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
            .previewDevice("iPhone 12")
            .environmentObject(PaletteStore(named: "Preview"))
//            .preferredColorScheme(.dark)
    }
}
