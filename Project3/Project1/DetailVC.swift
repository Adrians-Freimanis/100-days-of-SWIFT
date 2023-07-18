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
    var picturesArraySize: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        picturesArraySize = pictures.count//Set the size of picture array
        
        for (index, picture) in pictures.enumerated(){
            if picture == selectedImage{
                picturePosition = index + 1
            }
        }//loop through picture array and if picture matches the selected image asign the index of that image to our picture position with + 1 as we start a array from index 0.
        
        
        title = String(format: "Picture %d of %d", picturePosition, picturesArraySize)
        navigationItem.largeTitleDisplayMode = .never //Display title as small
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        
        
        
        

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

    @objc func shareTapped(){
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8)else{
            print("No image found")
            return
        }
        
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
