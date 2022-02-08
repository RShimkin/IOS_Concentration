//
//  HardViewController.swift
//  Concentration
//
//  Created by Роман on 07.01.2022.
//

import UIKit

class HardViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = theme.BGColor
        for but in buttons {
            but.backgroundColor = theme.buttonColor
            but.layer.borderColor = theme.mainColor?.cgColor
            but.layer.borderWidth = 1
            but.layer.cornerRadius = 3
            but.setTitleColor(theme.fontColor, for: UIControl.State.normal)
        }
        for but in cardButtons {
            but.backgroundColor = theme.mainColor
            but.setTitleColor(theme.fontColor, for: UIControl.State.normal)
            but.layer.cornerRadius = 4
        }
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    var emojiChoices = ""
    /*
    var BGColor: UIColor = .white
    var MainColor: UIColor = .yellow
    var fontColor: UIColor = .black
    var buttonColor: UIColor = .cyan
    */
    
    var theme: Theme! {
        didSet {
            emojiChoices = theme.emoji ?? emojiChoices
            emoji = [:]
            //updateViewFromModel()
        }
    }
    
    
    @IBOutlet var buttons: [UIButton]!

    @IBAction func startNewGame(_ sender: UIButton) {
        game.reset()
        updateViewFromModel()
        scoreCount = 0
        showRequests = 0
    }
    
    private var active: Bool = true
    
    @IBAction func shuffle(_ sender: UIButton) {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    var showRequests = 0
    
    @IBAction func showForSecond(_ sender: UIButton) {
        if showRequests == 0 {
            showRequests += 1
            showCards()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: false)
        }
    }
    
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
    
    private(set) var scoreCount = 0 {
        didSet {
            updateScoreCountLabel()
        }
    }

    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            //.strokeColor: UIColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            .strokeColor: theme.buttonColor
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateScoreCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: theme.buttonColor
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

    private var emoji = [Card : String]()

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
