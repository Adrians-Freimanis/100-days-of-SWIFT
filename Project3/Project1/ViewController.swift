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
        
        title = "Storm Viewer"//Set title
        navigationController?.navigationBar.prefersLargeTitles = true //Set title as large
        
        let fm = FileManager.default //Declare the file manager
        let path = Bundle.main.resourcePath! // Declare path
        let items = try! fm.contentsOfDirectory(atPath: path) // Declare fm directory
        
        for item in items { //loop through our item
            if item.hasPrefix("nssl"){ //if our item is picture add to array
                pictures.append(item)
            }
        }
        
        // Use the sorted() sequence to sort the pictures array of elements(CHALLANGE)
        pictures = pictures.sorted()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count //Return the amount of rows of the picture count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        cell.textLabel?.text = pictures[indexPath.row]
        
        return cell//Return in cell the text of the image
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailVC{
            vc.selectedImage = pictures[indexPath.row]
            vc.pictures = pictures
            navigationController?.pushViewController(vc, animated: true)
        }//When selecting row initiate DetailVC with image
    }

}

