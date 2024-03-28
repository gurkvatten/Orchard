//
//  CardListView.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-02-20.
//

import SwiftUI
import  FirebaseFirestoreInternal
import SDWebImageSwiftUI




struct CardListView: View {
    @State var cards: [Card] = []
    @State private var selectedCategory: String = "Hårdvara"
    @State private var secondaryColor: Color = .blue
    
    var categories: [String] {
            var categoriesSet = Set<String>()
            for card in cards {
                categoriesSet.insert(card.category)
            }
            return Array(categoriesSet)
        }
    var filteredCards: [Card] {
            if selectedCategory.isEmpty {
                return cards
            } else {
                return cards.filter { $0.category == selectedCategory }
            }
        }
    
    var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        Picker("Choose a category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category).tag(category)
                                                                }
                        }
                                            .foregroundColor(secondaryColor)
                                            .padding()
                        ForEach(filteredCards) { card in
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
                                                .foregroundColor(secondaryColor)
                                            Text(card.heading)
                                                .font(.title)
                                                .fontWeight(.black)
                                                .foregroundColor(.primary)
                                                .lineLimit(3)
                                            Text(card.year)
                                                .font(.caption)
                                                .foregroundColor(secondaryColor)
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
                        Button("Change Accent Color") {
                                               secondaryColor = Color(red: .random(in: 0...1),
                                                                    green: .random(in: 0...1),
                                                                    blue: .random(in: 0...1))
                                            }
                                            .padding()
                    }
                    .navigationTitle("Orchard")
                    .toolbarBackground(Color.gray.opacity(0.1), for: .navigationBar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
                    
                }
            }
            
            .onAppear {
                self.fetchCards()
            }
            .onAppear() {
                if let firstCategory = categories.first {
                    selectedCategory = firstCategory
                }
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
                    let audioUrl = data["audioUrl"] as? String ?? ""
                    let modelUrl = data["modelUrl"] as? String ?? ""
                    
                    return Card(category: category, heading: heading, year: year, imageName: imageName, article: article, audioUrl: audioUrl, modelUrl:modelUrl )
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
