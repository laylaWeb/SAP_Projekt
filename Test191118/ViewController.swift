//
//  ViewController.swift
//  Test191118
//
//  Created by s0554822@htw-berlin.de on 27.11.18.
//  Copyright © 2018 Sarah. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class ViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://www.apple.com/support/systemstatus/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        print (myRequest)
        
        webView.evaluateJavaScript("document.documentElement.innerHTML.toString()",
                                   completionHandler: { (html: Any, error: Error?) in
                                    print(html)
        })
        
        
        
        
    }
}

