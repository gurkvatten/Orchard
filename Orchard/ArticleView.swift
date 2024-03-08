//
//  ArticleView.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-03-07.
//

import SwiftUI
import AVKit

struct ArticleView: View {
    let card: Card
    
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
                
                if !card.audioUrl.isEmpty{
                    Button("Spela startljud") {
                        playAudio()
                    }
                }
                
                
            }
        }
    }
    
    func playAudio() {
        guard let url = URL(string: card.audioUrl) else { return }
            let player = AVPlayer(url: url)
            player.play()
        }
    
    struct ArticleView_Previews: PreviewProvider {
        static var previews: some View {
            let sampleCard = Card(category: "Sample Category", heading: "Sample Heading", year: "2024", imageName: "sampleImage", article: "This is a sample article content.", audioUrl: "https://firebasestorage.googleapis.com/v0/b/orchard-83942.appspot.com/o/boing_lmke36X.mp3?alt=media&token=f5202487-d35f-4dce-b02f-65b800e52dfc")
            return ArticleView(card: sampleCard)
        }
    }
}
