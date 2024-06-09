//
//  PayPalViewController.swift
//  UniqloApp
//

import UIKit
import WebKit

class PayPalViewController: BaseVC, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Paypal"
        // Initialize WKWebView
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        // Load PayPal page
        if let url = URL(string: "https://your-paypal-page-url.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // WKNavigationDelegate method to handle navigation events if needed
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading PayPal page")
    }
}
