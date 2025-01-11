//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by Dhruv Chhatbar on 06/01/25.
//

import Foundation

extension UserDefaults{
    func palettes(forKey key: String) -> [Palette]{
        if let jsonData = data(forKey: key)
            ,let decodePalettes = try? JSONDecoder().decode([Palette].self, from: jsonData){
            return decodePalettes
        }
        else{
            return []
        }
            
    }
    func set(_ palettes: [Palette], forKey key: String){
        let data = try? JSONEncoder().encode(palettes)
        set(data, forKey: key)
    }
}

class PaletteStore: ObservableObject{
    let name: String
    
    private var userDefaultKey:String { "PaletteStore:" + name }
    
    var palettes: [Palette]{
        get{
            UserDefaults.standard.palettes(forKey: userDefaultKey)
        }
        set{
            if !newValue.isEmpty{
                UserDefaults.standard.setValue(newValue, forKey: userDefaultKey)
                objectWillChange.send()
            }
        }
    }
    
    init(named name: String) {
        self.name = name
        if palettes.isEmpty{
            palettes = Palette.builtins
            if palettes.isEmpty{
                palettes.append(Palette(name: "Warning", emojis: "⚠️"))
            }
        }
    }
    @Published private var _cursorIndex: Int = 0
    var cursorIndex: Int{
        get{ boundsCheckedPaletteIndex(_cursorIndex)}
        set{ _cursorIndex = boundsCheckedPaletteIndex(newValue)}
    }
    
    
    private func boundsCheckedPaletteIndex(_ index: Int)-> Int{
        var index = index % palettes.count
        if index < 0{
            index += palettes.count
        }
        return index
    }
    
    func insert(_ palette: Palette, at insertionIndex: Int? = nil) { // "at" default is cursorIndex
        let insertionIndex = boundsCheckedPaletteIndex(insertionIndex ?? cursorIndex)
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            palettes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex)
            palettes.replaceSubrange(insertionIndex...insertionIndex, with: [palette])
        }
        else{
            palettes.insert (palette, at: insertionIndex)
        }
    }
    func insert(name: String, emojis: String, at index: Int? = nil) {
        insert(Palette(name: name, emojis: emojis), at: index)
    }
    func append(_ palette: Palette) {// at end of palettes
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            if palettes.count == 1 {
                palettes = [palette]
            } else {
                palettes.remove(at: index)
                palettes .append(palette)
            }
        }
        else{
            palettes.append(palette)
        }
    }
}
