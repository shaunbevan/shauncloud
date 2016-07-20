//
//  WebViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/15/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import OAuthSwift
import UIKit

class WebViewController: OAuthWebViewController {
    
    var targetURL : NSURL = NSURL()
    let webView : UIWebView = UIWebView()
    let networking = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRectMake(0, 20, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.webView.frame = frame
        self.webView.scalesPageToFit = true
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        loadAddressURL()

    }
    
    override func handle(url: NSURL) {
        targetURL = url
        super.handle(url)
        
        loadAddressURL()
    }
    
    func loadAddressURL() {
        let req = NSURLRequest(URL: targetURL)
        self.webView.loadRequest(req)
    }

}

// MARK: delegate
    extension WebViewController: UIWebViewDelegate {
        func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            if let url = request.URL where (url.scheme == "oauth-swift"){
                self.dismissWebViewController()
            }
            return true
        }
    }