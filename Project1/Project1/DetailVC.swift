//
//  DetailVC.swift
//  Project1
//
//  Created by adrians.freimanis on 17/07/2023.
//

import UIKit

class DetailVC: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    var pictures: [String] = []
    var picturePosition: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let picturesArraySize = pictures.count
        
        for (index, picture) in pictures.enumerated() {
            if picture == selectedImage {
                picturePosition = index // Assign the index to picturePosition
                break // Exit the loop early once we find the selectedImage
            }else{
                assert(selectedImage == picture, "There is no picture")
            }
        }
        
        title = String(format: "Picture %d of %d", picturePosition, picturesArraySize)
        
        
        
//                if let selectedImage = selectedImage, let pictureIndex = pictures.firstIndex(of: selectedImage) {
//                    let picturePosition = pictureIndex + 1
//                    let picturesArraySize = pictures.count
//
//                    title = String(format: "Picture %d of %d", picturePosition, picturesArraySize)
//                } else {
//                    title = "Error"
//                }
        
        
        navigationItem.largeTitleDisplayMode = .never //Display title as small
        

        if let imageToLoad = selectedImage{ //Set the name of the image as selected image
            imageView.image = UIImage(named: imageToLoad)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {//show navigation controller on tap of screen
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {//hide navigation controller on tap of screen
        navigationController?.hidesBarsOnTap = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
