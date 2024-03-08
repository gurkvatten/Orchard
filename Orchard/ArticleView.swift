//
//  ArticleView.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-03-07.
//

import SwiftUI

struct ArticleView: View {
    let article: Article
    
    var body: some View {
        VStack {
            Text(article.title)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text(article.content)
                .padding()
            
            Spacer()
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleArticle = Article(title: "Sample Article", content: "This is a sample article content.")
        return ArticleView(article: sampleArticle)
    }
}
