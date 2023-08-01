//
//  ViewController.swift
//  Project2
//
//  Created by adrians.freimanis on 18/07/2023.
//

import UIKit
import UserNotifications
import UserNotificationsUI

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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(infoTapped))
        
        
        
        
        askQuestion()
    }
    
    
    func scheduleReminder() {
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Come back and play!"
        content.body = "You've completed 10 questions. Play again to improve your score!"
        content.sound = UNNotificationSound.default

        // Create the notification trigger for 1 week (7 days) from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7 * 24 * 60 * 60, repeats: false)

        // Create the notification request
        let request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)

        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Reminder notification scheduled successfully.")
            }
        }
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
        
        
        let contry = contries[correctAnswer].uppercased()
        title = "\(contry)(\(buttonTappedCount))"
        
        let finalAC = UIAlertController(title: "Result", message: "You answered 10 questions and got \(score) correct!", preferredStyle: .alert)
        finalAC.addAction(UIAlertAction(title: "reset", style: .default, handler: resetGame))
        
        if(buttonTappedCount == 10){
            scheduleReminder()
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
    
    
    @objc func infoTapped(){
        
        let ac = UIAlertController(title: title, message: "Your current score is \(score)", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Back", style: .default, handler: { [weak self] _ in
               self?.dismiss(animated: true, completion: nil)
           }))
        
        
        present(ac,animated:true)
        
    }
    
    
    

}

