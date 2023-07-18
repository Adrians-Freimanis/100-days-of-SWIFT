//
//  ViewController.swift
//  Project2
//
//  Created by adrians.freimanis on 18/07/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var ButtonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var ButtonThree: UIButton!
    
    var contries = [String]()
    var score = 0
    var correctAnswer = 0
    var buttonTappedCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contries += ["estonia", "france", "germany", "ireland", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        ButtonOne.layer.borderWidth = 1
        buttonTwo.layer.borderWidth = 1
        ButtonThree.layer.borderWidth = 1
        
        ButtonOne.layer.borderColor = UIColor.lightGray.cgColor
        buttonTwo.layer.borderColor = UIColor.lightGray.cgColor
        ButtonThree.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func resetGame(action: UIAlertAction! = nil){
        score = 0
        buttonTappedCount = 0
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil){
        contries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        ButtonOne.setImage(UIImage(named: contries[0]), for: .normal)
        buttonTwo.setImage(UIImage(named: contries[1]), for: .normal)
        ButtonThree.setImage(UIImage(named: contries[2]), for: .normal)
        
        
        var contry = contries[correctAnswer].uppercased()
        title = "\(contry)(\(buttonTappedCount))"
        
        let finalAC = UIAlertController(title: "Result", message: "You answered 10 questions and got \(score) correct!", preferredStyle: .alert)
        finalAC.addAction(UIAlertAction(title: "reset", style: .default, handler: resetGame))
        
        if(buttonTappedCount == 10){
            present(finalAC, animated: true)
        }
    }
    
   
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        buttonTappedCount += 1
        
        var title: String
        
        if sender.tag == correctAnswer{
            title = "Correct"
            score += 1
        } else{
            title = "Wrong"
            score -= 1
        }
        if sender.tag == correctAnswer{
            let ac = UIAlertController(title: title, message: "Your score is \(score). You got the answer correct", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
        }else{
            let ac = UIAlertController(title: title, message: "Your score is \(score).You got the answer wrong", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
        
        
        
    }
    

}

