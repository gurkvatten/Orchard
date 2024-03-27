//
//  Card.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-03-27.
//

import Foundation

struct Card: Identifiable {
    let id = UUID()
    let category: String
    let heading: String
    let year: String
    let imageName: String
    let article: String
    let audioUrl: String
    let modelUrl: String
}
