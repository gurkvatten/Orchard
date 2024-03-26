//
//  ArticleView.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-03-07.
//

import SwiftUI
import SceneKit
import AVKit
import AVFoundation


struct ArticleView: View {
    let card: Card
    @State var isModelDisplayed = false
    @State var scene: SCNScene?
    @State private var audioPlayer: AVPlayer?
    
    var body: some View {
        ScrollView{
            VStack {
                Text(card.heading)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                AsyncImage(url: URL(string: card.imageName)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                
                Text(card.year)
                    .font(.title3)
                    .padding()
                
                Text(card.article)
                    .padding()
                
                Spacer()
                
                if !card.audioUrl.isEmpty {
                    Button("Spela startljud") {
                        playAudio()
                    }
                    .padding()
                }
                
                Spacer()
                
                if !isModelDisplayed {
                    Button("Visa modell") {
                        fetchModel()
                    }
                } else {
                    if let scene = scene {
                        SceneKitContentView(scene: scene)
                                        .frame(width: 300, height: 300)
                    } else {
                        ProgressView("Laddar modell...")
                            .padding()
                    }
                }
            }
            .padding()
        }
        .onAppear {
            
        }
    }
    
    func fetchModel() {
            guard let modelUrl = URL(string: card.modelUrl) else {
                print("Fel: Ogiltig modell-URL")
                return
            }
            
            print("Hämtar modell från URL: \(modelUrl)")
            
            URLSession.shared.dataTask(with: modelUrl) { data, response, error in
                if let error = error {
                    print("Fel vid hämtning av modell: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    do {
                        let scene = try SCNScene(url: modelUrl, options: nil)
                        DispatchQueue.main.async {
                            self.scene = scene
                            self.isModelDisplayed = true
                        }
                    } catch {
                        print("Error loading model from URL: \(modelUrl)")
                        print("Error: \(error)")
                    }
                } else {
                    print("Ingen data returnerades från servern.")
                }
            }.resume()
        }
    
    func playAudio() {
        guard let url = URL(string: card.audioUrl) else {
            print("Fel: Ogiltig ljud-URL")
            return
        }
        
        print("Spelar upp ljud från URL: \(url)")
        
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        
        let playerObserver = AudioPlayerObserver(player: audioPlayer!)
        
        audioPlayer?.play()
    }
    
    
    
    
    struct SceneKitContentView: UIViewRepresentable {
        let scene: SCNScene?
        let backgroundColor = UIColor.white
        
        func makeUIView(context: Context) -> SCNView {
            let sceneView = SCNView()
            if let scene = scene {
                sceneView.scene = scene
                    
            }
            sceneView.backgroundColor = backgroundColor
            return sceneView
        }
        
        func updateUIView(_ uiView: SCNView, context: Context) {
            if let scene = scene {
                uiView.scene = scene
            }
            uiView.backgroundColor = backgroundColor
        }
    }
    
    
    struct ArticleView_Previews: PreviewProvider {
        static var previews: some View {
            let sampleCard = Card(category: "Sample Category", heading: "Sample Heading", year: "2024", imageName: "sampleImage", article: "This is a sample article content.", audioUrl: "https://firebasestorage.googleapis.com/v0/b/orchard-83942.appspot.com/o/boing_lmke36X.mp3?alt=media&token=f5202487-d35f-4dce-b02f-65b800e52dfc", modelUrl: "https://firebasestorage.googleapis.com/v0/b/orchard-83942.appspot.com/o/macintosh%20sculpt%20001.obj?alt=media&token=aba69a8f-5169-4422-a656-e57188918051")
            return ArticleView(card: sampleCard)
        }
    }
}
