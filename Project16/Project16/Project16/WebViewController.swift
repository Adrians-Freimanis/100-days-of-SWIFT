//
//  WebViewController.swift
//  Project16
//
//  Created by adrians.freimanis on 28/07/2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var wikipediaURL: URL!
    @IBOutlet var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: wikipediaURL)
        webView.load(request)
        
    }
    

}
