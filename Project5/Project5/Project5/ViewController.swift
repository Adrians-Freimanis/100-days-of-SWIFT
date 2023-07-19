//
//  ViewController.swift
//  Project5
//
//  Created by adrians.freimanis on 19/07/2023.
//

import UIKit

class ViewController: UITableViewController{
    
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty{
            allWords = ["silkworm"]
        }
        
        startGame()
            
    }
    
    
    
    
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else{return}
            self?.submit(answer: answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    func isPossible(word: String) -> Bool {
        var tempWord = title!.lowercased()

        for letter in word {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }

        return true
    }

    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }

    
    
    
    
    
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()

        

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    
                    // Check if the submitted word is the same as the starter word
                    if lowerAnswer == title?.lowercased() {
                        showErorMessage(errorTitle: "You can't use the starter word", errorMessege: "This is not allowed!")
                    }
                    if lowerAnswer.isEmpty{
                        showErorMessage(errorTitle: "Empty messege", errorMessege: "You can't have a empty messege!")
                    }
                        else{
                        usedWords.insert(answer, at: 0)

                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)

                        return
                    }
                                           
                                        
                    
                } else {
                    
                    showErorMessage(errorTitle: "Word not recognised", errorMessege: "You can't just make them up, you know!")
                }
            } else {
                showErorMessage(errorTitle: "Word used already", errorMessege: "Be more original!")
            }
        } else {
            showErorMessage(errorTitle: "Word not possible", errorMessege: "You can't spell that word from '\(title!.lowercased())'!")
        }
        
    }
    
    
    func showErorMessage(errorTitle: String, errorMessege: String){
        let ac = UIAlertController(title: errorTitle, message: errorMessege, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    }
    
    

    
    @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

}

