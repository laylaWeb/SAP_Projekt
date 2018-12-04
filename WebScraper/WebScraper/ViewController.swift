//
//  ViewController.swift
//  WebScraper
//
//  Created by Jennifer Zander on 13.11.18.
//  Copyright © 2018 Jennifer Zander. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request("https://www.apple.com/de/support/systemstatus/").responseData() {
                response in
            print (response) // http url response
            
        }
    }
}

