//
//  ArticleView.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-03-07.
//

import SwiftUI

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
                
                Text(card.article)
                    .padding()
                
                Spacer()
            }
        }
    }
    
    struct ArticleView_Previews: PreviewProvider {
        static var previews: some View {
            let sampleCard = Card(category: "Sample Category", heading: "Sample Heading", year: "2024", imageName: "sampleImage", article: "This is a sample article content.")
            return ArticleView(card: sampleCard)
        }
    }
}
