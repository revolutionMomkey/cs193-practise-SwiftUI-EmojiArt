//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by 杜俊楠 on 2022/7/28.
//

import SwiftUI

struct Palette: Identifiable, Codable, Hashable {
    var name: String
    var emojis: String
    var id: Int
    
    fileprivate init(name: String, emojis: String, id: Int) {
        self.name = name
        self.emojis = emojis
        self.id = id
    }
}

class PaletteStore: ObservableObject {
    let name: String
    
    @Published var palettes = [Palette]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var UserDefaultKeys: String {
        "paletteStore" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(palettes), forKey: UserDefaultKeys)
        
// 2       UserDefaults.standard.set(palettes.map { [$0.name, $0.emojis, String($0.id)] } , forKey: UserDefaultKeys)
// 1       UserDefaults.standard.set(palettes, forKey: UserDefaultKeys)
    }
    
    private func restoreFromUserDefaults() {
        
        if let jsonData = UserDefaults.standard.data(forKey: UserDefaultKeys),
            let decodePalette = try? JSONDecoder().decode(Array<Palette>.self, from: jsonData) {
            palettes = decodePalette
        }
        
//        if let palettesAsPropertyList = UserDefaults.standard.array(forKey: UserDefaultKeys) as? [[String]] {
//            for palettesAsArray in palettesAsPropertyList {
//                if palettesAsArray.count == 3, let id = Int(palettesAsArray[2]), !palettes.contains(where: { $0.id == id}) {
//                    let palette = Palette(name: palettesAsArray[0], emojis: palettesAsArray[1], id: id)
//                    palettes.append(palette)
//                }
//            }
//        }
    }
    
    init(named name:String) {
        self.name = name
        restoreFromUserDefaults()
        if palettes.isEmpty {
            print("调用花瓣")
            insertPalette(named: "标题1", emojis: "☀️🌤⛅️🚙🚗🚘🚕🚖🏎🚚🛻🏈⚾️🏀⚽️")
            insertPalette(named: "标题2", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻☀️🌤⛅️🏈⚾️🏀⚽️")
            insertPalette(named: "标题3", emojis: "🏈⚾️🏀⚽️☀️🌤⛅️🚙🚗🚘🚕🚖🏎🚚🛻")
        }
        else {
            
        }
    }
    
    // Mark - Intent
    
    func palette(at index:Int) -> Palette {
        let safeIndex = min(max(index, 0), palettes.count - 1)
        return palettes[safeIndex]
    }
    
    @discardableResult
    func removePalette(at index: Int) -> Int {
        if palettes.count > 1, palettes.indices.contains(index) {
            palettes.remove(at: index)
        }
        return index % palettes.count
    }
    
    func insertPalette(named name: String, emojis: String? = nil, at index: Int = 0) {
        let unique = (palettes.max(by: {$0.id < $1.id})?.id ?? 0) + 1
        let palette = Palette(name: name, emojis: emojis ?? "", id: unique)
        let safeIndex = min(max(index, 0), palettes.count)
        palettes.insert(palette, at: safeIndex)
    }
    
    
    
    
    
    
}
