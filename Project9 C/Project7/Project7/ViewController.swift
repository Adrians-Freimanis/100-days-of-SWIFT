//
//  ViewController.swift
//  Project7
//
//  Created by adrians.freimanis on 19/07/2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    
    var filteredPetitions = [Petition]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(apiInfo))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(loadFilter))
        
        fetchPetitions()
    }
    
    @objc func loadFilter(){
        performSelector(inBackground: #selector(filterPetitions), with: nil)
    }
    
    @objc func apiInfo(){
        let ac = UIAlertController(title: "Info", message: "You are currently using the White House API", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    
    func fetchPetitions(){
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0{
            urlString =
            "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            urlString =
            "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if error != nil {
                    // Show the error alert when there is an error
                    DispatchQueue.main.async {
                        self.showError()
                    }
                    return
                }
                
                if let data = data {
                    self.parse(json: data)
                }
            }
            task.resume()
        }
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    
    func parse(json: Data){
        
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    
    @objc func filterPetitions(){
        
        let ac = UIAlertController(title: "Search content", message: nil, preferredStyle: .alert)
        
        ac.addTextField{(textField) in
            textField.placeholder = "Search"
        }
        
        let pushAction = UIAlertAction(title: "OK", style: .default){ [weak self] _ in
            if let textField = ac.textFields?.first{
                if let inputText = textField.text{
                    print(inputText)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        ac.addAction(pushAction)
        ac.addAction(cancelAction)
        present(ac, animated: true){
            ac.textFields?.first?.becomeFirstResponder()
        }
    }
        
        
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return petitions.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let petition = petitions[indexPath.row]
            
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = DetailVC()
            vc.detailItem = petitions[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    

