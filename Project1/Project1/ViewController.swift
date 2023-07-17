//
//  ViewController.swift
//  Project1
//
//  Created by adrians.freimanis on 17/07/2023.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fm = FileManager.default //Declare the file manager
        let path = Bundle.main.resourcePath! // Declare path
        let items = try! fm.contentsOfDirectory(atPath: path) // Declare fm directory
        
        for item in items { //loop through our item
            if item.hasPrefix("nssl"){ //if our item is picture add to array
                pictures.append(item)
            }
        }
        
        print(pictures)
    }
    


}

