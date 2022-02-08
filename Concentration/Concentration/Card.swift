//
//  Card.swift
//  Concentration
//
//  Created by Роман on 04.01.2022.
//

import Foundation

struct Card: Hashable {

    var hashValue: Int { return identifier }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int

    private static var identifierFactory = 0

    private static func getUniqueIdentifier() -> Int {
        identifierFactory  = (identifierFactory + 1) % 10
        return identifierFactory
    }

    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
