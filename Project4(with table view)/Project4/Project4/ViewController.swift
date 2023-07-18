//
//  ViewController.swift
//  Project4
//
//  Created by adrians.freimanis on 18/07/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com", "ebay.com"]
    
    
    override func loadView(){
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
       
        let backButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        
        let forwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        
        
        toolbarItems = [progressButton, spacer,backButton, forwardButton,  refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),options: .new, context: nil)
        
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
            webView.scrollView.contentInset = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
            webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        
        
        
        
        edgesForExtendedLayout = []
        
        
        // Customize the navigation bar's appearance
        navigationController?.navigationBar.backgroundColor = UIColor.lightGray // Change to the color you want
        navigationController?.navigationBar.tintColor = UIColor.systemBlue  // Change the color of bar button items (e.g., back button)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] // Change the title text color to white

        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        
       
        
        
    }
    
    
    

    @objc func openTapped(){
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
                if website == "ebay.com" {
                    ac.addAction(UIAlertAction(title: website, style: .default, handler: blockPage))
                } else {
                    ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
                }
            }

        ac .addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    
    func blockPage(action:UIAlertAction){
        let alertController = UIAlertController(title: "You are not allowed access", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Go Back", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
    }
    
    
    
    func openPage(action: UIAlertAction){
        
        guard let actionTitle = action.title else{return}
        guard let url = URL(string: "https://" + actionTitle) else {return}
        webView.load(URLRequest(url: url))
    }
    
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        
        // Set the navigation bar color after web view finishes loading its content
        navigationController?.navigationBar.barTintColor = UIColor.lightGray  // Change to the color you want
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host{
            for website in websites{
                if host.contains(website){
                decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
    }


}

