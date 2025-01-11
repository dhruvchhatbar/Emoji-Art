//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Dhruv Chhatbar on 06/01/25.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var store: PaletteStore
    var body: some View {
        HStack{
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()
    }
    var chooser: some View{
        AnimatedActionButton(systemImage: "paintpalette", action: {
            store.cursorIndex += 1
        })
        .contextMenu{
//            gotoMenu
            AnimatedActionButton("New", systemImage: "plus") {
                store.append(Palette(name: "Math", emojis: "➕➖♾️➗"))
            }
            AnimatedActionButton("Delete", systemImage: "minus.circle",role: .destructive) {
                store.palettes.remove(at: store.cursorIndex)
            }
            
        }
    }
    
    private var gotoMenu: some View{
        Menu{
            ForEach(store.palettes){ palette in
                AnimatedActionButton(palette.name){
                }
            }
        }label: {
            Label("Go to", systemImage: "text.insert")
        }
    }
    
    func view(for palette: Palette) -> some View{
        HStack{
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
        .id(palette.id)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
    }
}
struct ScrollingEmojis: View {
    let emojies: [String]
    init(_ emojies: String) {
        self.emojies = emojies.uniqued.map({String($0)})
    }
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojies,id: \.self, content: { emoji in
                    Text(emoji)
                        .draggable(emoji)
                })
            }
        }
    }
}


#Preview {
    PaletteChooser()
        .environmentObject(PaletteStore(named: "Preview"))
}
