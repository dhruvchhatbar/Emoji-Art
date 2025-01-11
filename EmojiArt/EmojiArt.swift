//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Dhruv Chhatbar on 28/12/24.
//

import Foundation

struct EmojiArt: Codable{
    
    var background: URL?
    private (set) var emoji = [Emoji]()
    
    func json() throws ->  Data{
         let encoded = try JSONEncoder().encode(self)
        print("EmojiArt = \(String(data: encoded, encoding: .utf8) ?? "nil")")
        return encoded
    }
    
    init(json: Data) throws{
        self = try JSONDecoder().decode(EmojiArt.self, from: json)
    }
    
    init() {
        
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Positionn, size: Int){
        self.uniqueEmojiId += 1
        self.emoji.append(Emoji(
            id: uniqueEmojiId,
            string: emoji,
            position: position,
            size: size))
        
    }
    
    struct Emoji: Identifiable, Codable{
        var id: Int
        let string: String
        var position: Positionn
        var size: Int
        
        struct Positionn: Codable{
            var x: CGFloat
            var y: CGFloat
        }
    }
}
