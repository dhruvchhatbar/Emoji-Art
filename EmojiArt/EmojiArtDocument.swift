//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Dhruv Chhatbar on 28/12/24.
//

import SwiftUI

class EmojiArtDocument: ObservableObject{
    
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt(){
        didSet{
            autoSave()
        }
    }
    private let autoSaveUrl : URL = URL.documentsDirectory.appendingPathComponent("AutoSaved.emojiArt")
    private func autoSave(){
        save(to: autoSaveUrl)
        print("AutoSaved to", autoSaveUrl)
    }
    private func save(to url: URL){
        do{
            let data = try emojiArt.json()
            try data.write(to: url)
        }
        catch let error{
            print("EmojiArtDocument error while saving",error.localizedDescription)
        }
        print("AutoSaved to", autoSaveUrl)
    }
    
    init() {
        if let data = try? Data(contentsOf: autoSaveUrl),let autoSavedEmojiArt = try? EmojiArt(json: data){
            emojiArt = autoSavedEmojiArt
        }
    }
    
    var emojis: [Emoji]{
        emojiArt.emoji
    }
    var background : URL?{
        emojiArt.background
    }
    
    //MARK: Intents
    func setBackground(_ url: URL?){
        emojiArt.background = url
    }
    func addEmoji(_ emoji: String, at position: Emoji.Positionn, size: Int){
        emojiArt.addEmoji(emoji, at: position, size: size)
    }
}
extension EmojiArt.Emoji{
    var font: Font{
        Font.system(size: CGFloat(size))
    }
}
extension EmojiArt.Emoji.Positionn{
    func `in`(_ geometry: GeometryProxy) -> CGPoint{
        
        let center = geometry.frame(in: .local).center
        
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
    
}
