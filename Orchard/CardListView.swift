//
//  CardListView.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-02-20.
//

import SwiftUI

struct CardListView: View {
    var body: some View {
        var category: String
        var heading: String
        var year: String
        
           VStack {
               Image("swiftui-button")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
    
               HStack {
                   VStack(alignment: .leading) {
                       Text(category)
                           .font(.caption)
                           .foregroundColor(.secondary)
                       Text(heading)
                           .font(.title)
                           .fontWeight(.black)
                           .foregroundColor(.primary)
                           .lineLimit(3)
                       Text(year)
                           .font(.caption)
                           .foregroundColor(.secondary)
                   }
                   .layoutPriority(100)
                   
                   
    
                   Spacer()
               }
               .padding()
           }
           .cornerRadius(10)
            
           .overlay(
               RoundedRectangle(cornerRadius: 10)
                   .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
           )
           .padding([.top, .horizontal])
           
       }
    
   }

#Preview {
    CardListView()
}
