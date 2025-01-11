//
//  Palette.swift
//  EmojiArt
//
//  Created by Dhruv Chhatbar on 06/01/25.
//

import Foundation

struct Palette: Identifiable, Codable{
    var name: String
    var emojis: String
    var id = UUID()
    
    static var builtins : [Palette] { [
        Palette(name: "Vehicles", emojis:"🏎️🚌🚍🚎🚐🚑🚒🚓🚔🚕🚖🚗🚘🚙🚚🚛🛻🚜🚲🛴🛵🛺"),
        Palette(name: "Sports", emojis: "🤺🏇⛷️🏂🏌️🏌️‍♂️🏌️‍♀️🏄🏄‍♂️🏊🫃🧎"),
        Palette(name: "Music", emojis: "🎵🎶〽️📻🎙️🎤🎧🎷🎸🎹🪗"),
        Palette(name: "Animals", emojis:"🐒🦍🦧🐶🐕🦮🐕‍🦺🐩🐺🦊🦝🐱🐈🐈‍⬛🦁"),
        Palette(name: "Animal Faces", emojis: "🐻🐻‍❄️🐨🐼🦥🦦🦨🦘🦡🐾🦃🐔🐓🐣🐤"),
        Palette(name: "Flora",emojis: "🌷🌺🥀🌼🌸💐🏵️🪷"),
        Palette(name: "Weather",emojis: "🌪️🌫️🌈☔💧💦🌊🧣🧤🌂☂️"),
        Palette(name: "COVID", emojis: "😧😨😰😥😢😭😱😖😣😞😓😩"),
        Palette(name: "Faces" , emojis: "👩‍🦳🧑‍🦳👩‍🦲🧑‍🦲👱‍♀️👱‍♂️🧓👴👵🙍🙍‍♂️🙍‍♀️🙎"),
    ]
    }
}
