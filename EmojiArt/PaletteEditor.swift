//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by 杜俊楠 on 2022/8/7.
//

import SwiftUI

struct PaletteEditor: View {
    
    @Binding  var palette: Palette
    
    var body: some View {
        Form {
            nameSection
            addEmojiSection
            removeEmojiSection
        }
        .navigationTitle("编辑: \(palette.name)")
        .frame(minWidth: 300, minHeight: 350)
    }
    
    private var nameSection: some View {
        Section(header: Text("种类")) {
            TextField("Name", text: $palette.name)
        }
    }
    
    @State private var emojisToAdd: String = ""
    
    private var addEmojiSection: some View {
        Section(header: Text("添加的内容")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            palette.emojis = (emojis + palette.emojis)
                .filter{ $0.isEmoji }
        }
    }
    
    private var removeEmojiSection: some View {
        Section(header: Text("删除的内容")) {
            let emojis = palette.emojis.map{ String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.removeAll(where: { String($0) == emoji } )
                            }
                        }
                }
            }
            
            
        }
    }
    
    
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
//        Text("verbatim")
        PaletteEditor(palette: .constant(PaletteStore(named:"Preview").palette(at:3)))
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
