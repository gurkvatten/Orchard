//
//  ArticleView.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-03-07.
//

import SwiftUI
import SceneKit
import AVKit


struct ArticleView: View {
    let card: Card
    @State private var isModelDisplayed = false
    @State private var scene: SCNScene?

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
                }
                
                Spacer()
                                
                                if !isModelDisplayed {
                                    Button("Visa modell") {
                                        downloadSceneTask()
                                    }
                                } else {
                                    if let scene = scene {
                                        SceneKitView(scene: scene)
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
            fetchModel()
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
            // Fortsätt med modellhantering
        }.resume()
    }

    
    func playAudio() {
        guard let url = URL(string: card.audioUrl) else {
            print("Fel: Ogiltig ljud-URL")
            return
        }
        print("Spelar upp ljud från URL: \(url)")
        let player = AVPlayer(url: url)
        player.play()
    }

    func downloadSceneTask() {
            guard let modelUrl = URL(string: card.modelUrl) else { return }
            let downloadTask = URLSession.shared.downloadTask(with: modelUrl) { location, response, error in
                guard let location = location, error == nil else {
                    print("Error downloading model data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let fileManager = FileManager.default
                let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationUrl = documentsUrl.appendingPathComponent("model.scn")
                
                if fileManager.fileExists(atPath: destinationUrl.path) {
                            do {
                                try fileManager.removeItem(at: destinationUrl)
                                print("Existing file removed")
                            } catch {
                                print("Error removing existing file: \(error)")
                                return
                            }
                        }
                
                do {
                    try fileManager.moveItem(at: location, to: destinationUrl)
                    print("Model downloaded successfully")
                    
                    DispatchQueue.main.async {
                        self.loadModel(at: destinationUrl)
                    }
                } catch {
                    print("Error moving file: \(error)")
                }
            }
            
            downloadTask.resume()
        }

        func loadModel(at url: URL) {
            guard let scene = try? SCNScene(url: url, options: nil) else {
                print("Error loading model from \(url)")
                return
            }
            
            self.scene = scene
            self.isModelDisplayed = true
        }
    
    struct SceneKitView: UIViewRepresentable {
        let scene: SCNScene?
        
        
        func makeUIView(context: Context) -> SCNView {
            let sceneView = SCNView()
            if let scene = scene {
                sceneView.scene = scene
            }
            return sceneView
        }

        func updateUIView(_ uiView: SCNView, context: Context) {
            if let scene = scene {
                uiView.scene = scene
            }
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCard = Card(category: "Sample Category", heading: "Sample Heading", year: "2024", imageName: "sampleImage", article: "This is a sample article content.", audioUrl: "https://firebasestorage.googleapis.com/v0/b/orchard-83942.appspot.com/o/boing_lmke36X.mp3?alt=media&token=f5202487-d35f-4dce-b02f-65b800e52dfc", modelUrl: "https://firebasestorage.googleapis.com/v0/b/orchard-83942.appspot.com/o/macintosh%20sculpt%20001.obj?alt=media&token=aba69a8f-5169-4422-a656-e57188918051")
        return ArticleView(card: sampleCard)
    }
}
