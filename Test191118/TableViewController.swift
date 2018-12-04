//
//  TableViewController.swift
//  Test191118
//
//  Created by Sarah on 20.11.18.
//  Copyright © 2018 Sarah. All rights reserved.
//

import UIKit
import WebKit

class TableViewController: UITableViewController, WKUIDelegate {
    
    let headlines = ["Apple Services","Amazon Web Services"]
    
    let status = [["App Store", "Device Enrollment Programm", "iOS Device Activation", "Mac App Store", "macOS Software Update", "Volume Purchase Program"],
                  ["Asia Pacific", "Europe", "North America", "South America" ]]
    
    var webView: WKWebView!
    
    @IBAction func Settings(_ sender: UIBarButtonItem) {

    }
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
        
        //...
        //class WKNavigation : NSObject
        
        optional func webView(_ webView: WKWebView,
                              didFinish navigation: WKNavigation!)
        
        webView.evaluateJavaScript("document.documentElement.innerHTML.toString()",
                                   completionHandler: { (html: Any, error: Error?) in
                                    print(html)
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return status.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headlines[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return status[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCellApple", for: indexPath)

        cell.textLabel?.text = status[indexPath.section][indexPath.row]

        return cell
    }
}
