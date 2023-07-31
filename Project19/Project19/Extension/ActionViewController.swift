//
//  ActionViewController.swift
//  Extension
//
//  Created by adrians.freimanis on 31/07/2023.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(list))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [unowned self] (dict, error) in
                    let itemDictionary = dict as! NSDictionary
                    let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary

                    self.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self.pageURL = javaScriptValues["URL"] as? String ?? ""

                    DispatchQueue.main.async {
                        self.title = self.pageTitle
                    }
                }
            }
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
           let argument: NSDictionary = ["customJavaScript": script.text]
           let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
           let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
           item.attachments = [customJavaScript]

           extensionContext?.completeRequest(returningItems: [item])
    }
    
    
    @IBAction func list(_ sender: Any){
        let ac = UIAlertController(title: "Pre-made actions", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Title", style: .default, handler: {
            _ in
            self.handleTitleAction()
        }))
        ac.addAction(UIAlertAction(title: "Version", style: .default, handler: {_ in
            self.handleVersionAction()
        }))
        ac.addAction(UIAlertAction(title: "URL", style: .default, handler: {_ in
            self.handleURLAction()
        }))
        
        present(ac, animated: true)
    }
    
    
    func handleTitleAction() {
        // Fill the text field with the document title
        script.text = "alert(document.title);"
    }

    func handleVersionAction() {
        // Fill the text field with the document version (replace 'YOUR_VERSION' with the actual version value)
        script.text = "alert('version: IOS 16.0');"
    }

    func handleURLAction() {
        // Fill the text field with the document URL
        script.text = "alert(pageURL);"
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
