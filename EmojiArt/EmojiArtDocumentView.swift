//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Dhruv Chhatbar on 28/12/24.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    
    @ObservedObject var document: EmojiArtDocument
    
    private let paletteEmojiSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                if document.background.isFetching{
                    ProgressView()
                        .scaleEffect(2)
                        .tint(.blue)
                        .position(Emoji.Positionn.zero.in(geometry))
                }
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
            }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
            .onTapGesture(count: 2, perform: {
                zoomToFit(document.bbox, in: geometry)
            })
            
            .onChange(of: document.background.failureReason) { reason in
                showBackgroundFailedAlert = reason != nil
            }
            .onChange(of: document.background.uiImage) { img in
                zoomToFit(img?.size, in: geometry)
            }
            .alert(
                "Set Background",
                   isPresented: $showBackgroundFailedAlert,
                presenting: document.background.failureReason) { reson in
                    Button("OK", role: .cancel){}
                } message: { reason in
                    Text(reason)
                }

        }
    }
    
    private func zoomToFit(_ size: CGSize?, in geometry: GeometryProxy) {
        if let size {
            zoomToFit(CGRect(center: .zero, size: size), in: geometry)
        }
    }
    
    private func zoomToFit(_ rect: CGRect, in geometry: GeometryProxy) {
        withAnimation {
            if rect.size.width > 0, rect.size.height > 0,
               geometry.size.width > 0, geometry.size.height > 0 {
                let hZoom = geometry.size.width / rect.size.width
                let vZoom = geometry.size.height / rect.size.height
                zoom = min(hZoom, vZoom)
                pan = CGOffset(
                    width: -rect.midX * zoom,
                    height: -rect.midY * zoom
                )
            }
        }
    }

    @State private var showBackgroundFailedAlert = false
    
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        if let img = document.background.uiImage{
            Image(uiImage: img)
                .position(Emoji.Positionn.zero.in(geometry))
        }
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .position(emoji.position.in(geometry))
        }
    }

    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    
    @GestureState private var gestureZoom: CGFloat = 1
    @GestureState private var gesturePan: CGOffset = .zero
    
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($gestureZoom) { inMotionPinchScale, gestureZoom, _ in
                gestureZoom = inMotionPinchScale
            }
            .onEnded { endingPinchScale in
                zoom *= endingPinchScale
            }
    }
    
    private var panGesture: some Gesture {
        DragGesture()
            .updating($gesturePan) { inMotionDragGestureValue, gesturePan, _ in
                gesturePan = inMotionDragGestureValue.translation
            }
            .onEnded { endingDragGestureValue in
                pan += endingDragGestureValue.translation
            }
    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(
                    emoji,
                    at: emojiPosition(at: location, in: geometry),
                    size: CGFloat(Int(paletteEmojiSize / zoom))
                )
                return true
            default:
                break
            }
        }
        return false
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Positionn {
        let center = geometry.frame(in: .local).center
        return Emoji.Positionn(
            x: Int((location.x - center.x - pan.width) / zoom),
            y: Int(-(location.y - center.y - pan.height) / zoom)
        )
    }
}

struct EmojiArtDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
            .environmentObject(PaletteStore(named: "Preview"))
    }
}
