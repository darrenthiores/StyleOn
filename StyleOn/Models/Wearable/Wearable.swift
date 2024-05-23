//
//  Wearable.swift
//  StyleOn
//
//  Created by Darren Thiores on 23/05/24.
//

import Foundation

class Wearable: Identifiable, Hashable, Equatable {
    static func == (lhs: Wearable, rhs: Wearable) -> Bool {
        lhs.id == rhs.id && lhs.scale == rhs.scale
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(scale)
    }
    
    let id: String
    let scale: [Double]
    
    init(id: String, scale: [Double]) {
        self.id = id
        self.scale = scale
    }
    
    static let defaultWearable: Wearable = getAllWearables()[0]
    static let searchWearable: Wearable = Wearable(
        id: "Search",
        scale: []
    )
    
    static func getAllWearables() -> [Wearable] {
        return [
            Wearable(
                id: "LongBlueShirt",
                scale: [0.25, 0.25, 0.25]
            ),
            Wearable(
                id: "BlueCollarPolo",
                scale: [0.25, 0.25, 0.25]
            ),
            Wearable(
                id: "LongPolo",
                scale: [0.25, 0.25, 0.25]
            ),
            Wearable(
                id: "WhitePants",
                scale: [0.4, 0.4, 0.4]
            ),
            Wearable(
                id: "TShirt",
                scale: [0.25, 0.25, 0.25]
            ),
            searchWearable
        ]
    }
    
    static func getShirts() -> [Wearable] {
        return [
            Wearable(
                id: "LongBlueShirt",
                scale: [0.25, 0.25, 0.25]
            ),
            Wearable(
                id: "BlueCollarPolo",
                scale: [0.25, 0.25, 0.25]
            ),
            Wearable(
                id: "LongPolo",
                scale: [0.25, 0.25, 0.25]
            ),
            Wearable(
                id: "TShirt",
                scale: [0.25, 0.25, 0.25]
            ),
            searchWearable
        ]
    }
    
    static func getPants() -> [Wearable] {
        return [
            Wearable(
                id: "WhitePants",
                scale: [0.4, 0.4, 0.4]
            ),
            searchWearable
        ]
    }
}
