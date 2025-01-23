//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Dhruv Chhatbar on 28/12/24.
//

import SwiftUI
import UniformTypeIdentifiers

//extension UTType{
//    static let emojiArt = UTType(exportedAs: "edu.stanford.cs193p.emojiart")
//}

class EmojiArtDocument: ObservableObject/*ReferenceFileDocument*/{
//    func snapshot(contentType: UTType) throws -> Data {
//        try emojiArt.json()
//    }
//    
//    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
//        FileWrapper(regularFileWithContents: snapshot)
//    }
//    
//    static var readableContentTypes: [UTType]{
//        [.emojiArt]
//    }
//    
//    required init(configuration: ReadConfiguration) throws {
//        if let data = configuration.file.regularFileContents{
//            
//        }
//        else{
//            throw CocoaError(.fileReadCorruptFile)
//        }
//    }
    
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
            autosave()
//            if emojiArt.background != oldValue.background{
//                Task{
//                    await fetchBackgroundImg()
//                }
//            }
        }
    }
    
    private let autosaveURL: URL = URL.documentsDirectory.appendingPathComponent("Autosaved.emojiart")
    
    private func autosave() {
        save(to: autosaveURL)
        print("autosaved to \(autosaveURL)")
    }
    
    private func save(to url: URL) {
        do {
            let data = try emojiArt.json()
            try data.write(to: url)
        } catch let error {
            print("EmojiArtDocument: error while saving \(error.localizedDescription)")
        }
    }
    
    init() {
        if let data = try? Data(contentsOf: autosaveURL),
           let autosavedEmojiArt = try? EmojiArt(json: data) {
            emojiArt = autosavedEmojiArt
        }
    }
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
//    var bbox: CGRect {
//        var bbox = CGRect.zero
//        for emoji in emojiArt.emojis {
//            bbox = bbox.union(emoji.bbox)
//        }
//        if let backgroundSize = background.uiImage?.size {
//            bbox = bbox.union(CGRect(center: .zero, size: backgroundSize))
//        }
//        return bbox
//    }

    var background: URL? {
        emojiArt.background
    }
    
//    @Published var background: Background = .none
//    
//    @MainActor
//    private func fetchBackgroundImg() async {
//        if let url = emojiArt.background{
//            background = .fetching(url)
//            do{
//                let img = try await fetchUIimage(from: url)
//                if url == emojiArt.background{ // if slow url loads late and user had changed something
//                    background = .found(img)
//                }
//            }
//            catch{
//                background = .failed("Couldn't set background: \(error.localizedDescription)")
//            }
//        }
//        else{
//            background = .none
//        }
//    }
//    private func fetchUIimage(from url: URL) async throws -> UIImage{
//        let (data, _) = try await URLSession.shared.data(from: url)
//        if let img = UIImage(data: data){
//            return img
//        }
//        else{
//            throw FetchError.badImgData
//        }
//    }
//    
//    enum FetchError: Error{
//        case badImgData
//        
//    }
    
//    enum Background {
//        case none
//        case fetching(URL)
//        case found(UIImage)
//        case failed(String)
//        
//        var uiImage: UIImage? {
//            switch self {
//            case .found(let uiImage): return uiImage
//            default: return nil
//            }
//        }
//        
//        var urlBeingFetched: URL? {
//            switch self {
//            case .fetching(let url): return url
//            default: return nil
//            }
//        }
//        
//        var isFetching: Bool { urlBeingFetched != nil }
//        
//        var failureReason: String? {
//            switch self {
//            case .failed(let reason): return reason
//            default: return nil
//            }
//        }
//    }
    // MARK: - Intent(s)
    
//    private func undoablyPerform(_ action: String,with undoManager: UndoManager? = nil, doit: ()->Void){
//        let oldEmojiArt = emojiArt
//        doit()
//        undoManager?.registerUndo(withTarget: self) { myself in //Redo -> Undoing and Undo
//            myself.undoablyPerform(action, with: undoManager) {
//                myself.emojiArt = oldEmojiArt
//            }
//        }
//        undoManager?.setActionName(action)
//    }
    
    func setBackground(_ url: URL?, undoWith undoManager: UndoManager? = nil) {
//        undoablyPerform("Set Background", with: undoManager) {
            emojiArt.background = url
//        }
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Positionn, size: CGFloat) {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }
    
    func move(_ emoji: Emoji, by offset: CGOffset) {
        let existingPosition = emojiArt[emoji].position
        emojiArt[emoji].position = Emoji.Positionn(
            x: existingPosition.x + Int(offset.width),
            y: existingPosition.y - Int(offset.height)
        )
    }
    
    func move(emojiWithId id: Emoji.ID, by offset: CGOffset) {
        if let emoji = emojiArt[id] {
            move(emoji, by: offset)
        }
    }
    
    func resize(_ emoji: Emoji, by scale: CGFloat) {
        emojiArt[emoji].size = Int(CGFloat(emojiArt[emoji].size) * scale)
    }
    
    func resize(emojiWithId id: Emoji.ID, by scale: CGFloat) {
        if let emoji = emojiArt[id] {
            resize(emoji, by: scale)
        }
    }
}
extension EmojiArt.Emoji{
    var font: Font{
        Font.system(size: CGFloat(size))
    }
    var bbox: CGRect {
        CGRect(
            center: position.in(nil),
            size: CGSize(width: CGFloat(size), height: CGFloat(size))
        )
    }
}
extension EmojiArt.Emoji.Positionn{
    func `in`(_ geometry: GeometryProxy?) -> CGPoint{
        
        let center = geometry?.frame(in: .local).center ?? .zero
        
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
    
}
