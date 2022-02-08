//
//  SettingsViewController.swift
//  Concentration
//
//  Created by Роман on 05.01.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var animals = "🐶🐱🐭🐹🐰🦊🐻🐼🦁🐸"
    private var creepy = "👿👹🎃🤡👻💀☠️👽👾🤖"
    private var sport = "⚽️🏀🏈🥎🏉🥏🎱🏓🥊⛸"
    
    private var animalsBG = UIColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    private var animalsMainColor: UIColor = .systemOrange
    private var animalsFontColor = UIColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    private var animalsButColor = UIColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
    
    private var creepyBG = UIColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    private var creepyMainColor: UIColor = .systemYellow
    private var creepyFontColor = UIColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    private var creepyButColor = UIColor(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
    
    private var sportBG = UIColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
    private var sportMainColor: UIColor = UIColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
    private var sportFontColor = UIColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    private var sportButColor = UIColor(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
    
    var bufferColor: UIColor = UIColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    var lastThemeNumber = 0
    var lastDifNumber = 0
    
    private func setThemeButtons() {
        themeButtons[lastThemeNumber].backgroundColor = bufferColor
        switch currentTheme {
        case 0:
            bufferColor = themeButtons[0].backgroundColor!
            themeButtons[0].backgroundColor = UIColor(#colorLiteral(red:1,green:1,blue:1, alpha:0))
            lastThemeNumber = 0
        case 1:
            bufferColor = themeButtons[1].backgroundColor!
            themeButtons[1].backgroundColor = UIColor(#colorLiteral(red:1,green:1,blue:1, alpha:0))
            lastThemeNumber = 1
        case 2:
            bufferColor = themeButtons[2].backgroundColor!
            themeButtons[2].backgroundColor = UIColor(#colorLiteral(red:1,green:1,blue:1, alpha:0))
            lastThemeNumber = 2
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        for but in difButtons {
            but.layer.cornerRadius = 5
        }
        for but in themeButtons {
            but.layer.cornerRadius = 5
        }
        currentTheme = Int(arc4random_uniform(3))
        setThemeButtons()
    }
    
    var currentTheme: Int = 0 {
        didSet {
            switch currentTheme {
            case 0:
                choosenTheme = animals
                choosenFontColor = animalsFontColor
                choosenBG = animalsBG
                choosenMainColor = animalsMainColor
                choosenButtonColor = animalsButColor
            case 1:
                choosenTheme = creepy
                choosenFontColor = creepyFontColor
                choosenBG = creepyBG
                choosenMainColor = creepyMainColor
                choosenButtonColor = creepyButColor
            case 2:
                choosenTheme = sport
                choosenFontColor = sportFontColor
                choosenBG = sportBG
                choosenMainColor = sportMainColor
                choosenButtonColor = sportButColor
            default:
                break
            }
        }
    }
    
    var choosenTheme: String? = nil
    var choosenBG: UIColor? = nil
    var choosenFontColor: UIColor? = nil
    var choosenMainColor: UIColor? = nil
    var choosenButtonColor: UIColor? = nil
    
    var difficulty: String? = "Easy"
    
    @IBOutlet var themeButtons: [UIButton]!
    
    @IBOutlet var difButtons: [UIButton]!
    
    @IBAction func themeButton(_ sender: UIButton) {
        let title = sender.title(for: UIControl.State.normal)
        switch title {
        case themeButtons[0].currentTitle:
            currentTheme = 0
        case themeButtons[1].currentTitle:
            currentTheme = 1
        case themeButtons[2].currentTitle:
            currentTheme = 2
        default:
            break
        }
        setThemeButtons()
    }
    
    @IBAction func DifButton(_ sender: UIButton) {
        difButtons[lastDifNumber].backgroundColor = UIColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        difficulty = sender.title(for: UIControl.State.normal)
        switch difficulty {
        case "Easy":
            lastDifNumber = 0
        case "Medium":
            lastDifNumber = 1
        case "Hard":
            lastDifNumber = 2
        default:
            break
        }
        sender.backgroundColor = UIColor(#colorLiteral(red:1,green:1,blue:1, alpha:0))
    }
    
    @IBAction func play(_ sender: UIButton) {
        
        if let dif = difficulty {
            switch dif {
            case "Easy":
                let controllerId = "EasyViewController"
                let newVC = storyboard?.instantiateViewController(withIdentifier: controllerId) as! EasyViewController
                newVC.theme = Theme(emoji: choosenTheme, mainColor: choosenMainColor, BGColor: choosenBG, fontColor: choosenFontColor, buttonColor: choosenButtonColor)
                navigationController?.pushViewController(newVC, animated: true)
            case "Medium":
                let controllerId = "MediumViewController"
                let newVC = storyboard?.instantiateViewController(withIdentifier: controllerId) as! MediumViewController
                newVC.theme = Theme(emoji: choosenTheme, mainColor: choosenMainColor, BGColor: choosenBG, fontColor: choosenFontColor, buttonColor: choosenButtonColor)
                navigationController?.pushViewController(newVC, animated: true)
            case "Hard":
                let controllerId = "HardViewController"
                let newVC = storyboard?.instantiateViewController(withIdentifier: controllerId) as! HardViewController
                newVC.theme = Theme(emoji: choosenTheme, mainColor: choosenMainColor, BGColor: choosenBG, fontColor: choosenFontColor, buttonColor: choosenButtonColor)
                navigationController?.pushViewController(newVC, animated: true)
            default:
                break
            }
        }
        
        
    }
}
