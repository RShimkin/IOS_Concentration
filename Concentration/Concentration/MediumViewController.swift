//
//  MediumViewController.swift
//  Concentration
//
//  Created by Роман on 05.01.2022.
//

import UIKit

class MediumViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = theme.BGColor
        //flipCountLabel.layer.backgroundColor = theme.buttonColor?.cgColor
        //ScoreCountLabel.layer.backgroundColor = theme.buttonColor?.cgColor
        for but in buttons {
            but.backgroundColor = theme.buttonColor
            but.setTitleColor(theme.fontColor, for: UIControl.State.normal)
        }
        for but in cardButtons {
            but.backgroundColor = theme.mainColor
            but.setTitleColor(theme.fontColor, for: UIControl.State.normal)
        }
    }

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var scoreCount = 0 {
        didSet {
            updateScoreCountLabel()
        }
    }

    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: theme.fontColor
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateScoreCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: theme.fontColor
        ]
        let attributedString = NSAttributedString(string: "Scores: \(scoreCount)", attributes: attributes)
        ScoreCountLabel.attributedText = attributedString
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet weak var ScoreCountLabel: UILabel! {
        didSet {
            updateScoreCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    var theme: Theme! {
        didSet {
            emojiChoices = theme.emoji ?? emojiChoices
            emoji = [:]
            //updateViewFromModel()
        }
    }

    private var emojiChoices = "" // просто строка эмоджи

    private var emoji = [Card : String]()

    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func shuf(_ sender: UIButton) {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        //game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        game.reset()
        updateViewFromModel()
        scoreCount = 0
        showRequests = 0
    }
    
    var showRequests = 0
    
    @IBAction func showForSecond(_ sender: UIButton) {
        if showRequests == 0 {
            showRequests += 1
            showCards()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: false)
        }
    }
    
    private var active: Bool = true
    
    @objc func timerFunc() {
        updateViewFromModel()
        active = true
    }
    
    private func showCards() {
        active = false
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if !card.isMatched {
                    button.setTitle(emoji (for: card), for: UIControl.State.normal)
                    button.backgroundColor = UIColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = UIColor(#colorLiteral(red:1,green:1,blue:1, alpha:0))
                }
            }
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if active == true {
            if let cardNumber = cardButtons.firstIndex(of: sender) {
                scoreCount += game.chooseCard(at: cardNumber)
                updateViewFromModel()
            } else {
                print ("chosen card was not in cardButtons")
            }
        }
    }

    private func updateViewFromModel() {
        updateFlipCountLabel()
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji (for: card), for: UIControl.State.normal)
                    button.backgroundColor = UIColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? UIColor(#colorLiteral(red:1,green:1,blue:1, alpha:0)) : theme.mainColor //UIColor(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))
                }
            }
        }
    }

    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(
                emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}
