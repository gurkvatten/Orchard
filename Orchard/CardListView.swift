//
//  CardListView.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-02-20.
//

import SwiftUI
import  FirebaseFirestoreInternal
import SDWebImageSwiftUI




struct Card: Identifiable {
    let id = UUID()
    let category: String
    let heading: String
    let year: String
    let imageName: String
    let article: String
}


struct CardListView: View {
    @State var cards: [Card] = []
    
    var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        ForEach(cards) { card in
                            NavigationLink(destination: ArticleView(card: card)) {
                                VStack {
                                    AsyncImage(url: URL(string: card.imageName)) { image in
                                                                            image.resizable()
                                                                                .aspectRatio(contentMode: .fit)
                                                                                .cornerRadius(10)
                                                                        } placeholder: {
                                                                            ProgressView()
                                                                        }
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
                    }
                    .navigationBarTitle("Orchard")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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
                    let article = data["article"] as? String ?? ""
                    let imageName = data["imageName"] as? String ?? ""
                    return Card(category: category, heading: heading, year: year, imageName: imageName, article: article)
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
