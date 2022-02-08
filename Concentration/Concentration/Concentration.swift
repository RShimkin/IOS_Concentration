//
//  Concentration.swift
//  Concentration
//
//  Created by Роман on 04.01.2022.
//

import Foundation

struct Concentration {
    private (set) var cards = [Card]()
    private (set) var flipCount = 0
    
    mutating func reset() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.strangeShuffle()
        flipCount = 0
    }

    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

    mutating func chooseCard(at index: Int) -> Int {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): choosen index not in the cards")
        var res: Int = 0
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                res = -2
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    res = 1
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        return res
    }
    
    mutating func shuffleCards() {
        cards.shuffle()
    }

    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        // var cardsBeforeShuffle = [Card]()
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
            // cardsBeforeShuffle += [card, card]
        }
        cards.strangeShuffle()
        /*
        for _ in cardsBeforeShuffle {
            let randomIndex = cardsBeforeShuffle.count.arc4random
            let randomCard = cardsBeforeShuffle.remove(at: randomIndex)
            cards.append(randomCard)
            // let size = cardsBeforeShuffle.count
            // cards.append(cardsBeforeShuffle.remove(at: Int(arc4random_uniform(UInt32(size)))))
        }
        */
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

extension Array {
    mutating func strangeShuffle() {
        for _ in 0..<self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
