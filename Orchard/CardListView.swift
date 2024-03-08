//
//  CardListView.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-02-20.
//

import SwiftUI
import  FirebaseFirestoreInternal

struct Article {
    let title: String
    let content: String
}


struct Card: Identifiable {
    let id = UUID()
    let category: String
    let heading: String
    let year: String
    let imageName: String
    let article: Article
}


struct CardListView: View {
    @State var cards: [Card] = []
    
    var body: some View {
        NavigationView {
            List(cards) { card in
                NavigationLink(destination: ArticleView(article: card.article)) {
                    VStack {
                        Image(card.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(card.category)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(card.heading)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(.primary)
                                    .lineLimit(3)
                                Text(card.year)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .layoutPriority(100)
                            
                            
                            
                        }
                        .padding()
                        
                        
                        
                    }
                    
                    .padding([.top, .horizontal])
                    .frame(height: min(400, max(300, self.textHeight(for: card.heading) + self.textHeight(for: card.year) + 40)))
                    
                    
                }
                .listRowBackground(Color.clear)
                .listRowSpacing(10)
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom))
            .navigationBarTitle("Orchard")
            
            
        }
        .onAppear {
            self.fetchCards()
        }
        
        
    }
        
    
    func textHeight(for text: String) -> CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .headline)
           let attributes = [NSAttributedString.Key.font: font]
           let size = text.size(withAttributes: attributes)
           return size.height
       }
    
    func fetchCards() {
        let db = Firestore.firestore()
        db.collection("cards").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = snapshot?.documents else { return }
                self.cards = documents.map { document in
                    let data = document.data()
                    let category = data["category"] as? String ?? ""
                    let heading = data["heading"] as? String ?? ""
                    let year = data["year"] as? String ?? ""
                    let article = Article(title: heading, content: "Dummy article content")
                    return Card(category: category, heading: heading, year: year, imageName: "imageName", article: article)
                }
            }
        }
    }
}
    


// Preview-kod
struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
