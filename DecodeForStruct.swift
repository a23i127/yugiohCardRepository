//
//  CardContents.swift
//  yuugioh
//
//  Created by 高橋沙久哉 on 2025/01/17.
//

import Foundation
struct cards : Decodable {
    let id: String
    let name: String
    let trueName: String
    let attribute :String
    let race: String //種族
    let lebel: String
    let imageUrl: String
    let searchTag: String
    let description: String
}
struct texts : Decodable {
    let text: String
    let position: Int
    let kategorie: String
}
