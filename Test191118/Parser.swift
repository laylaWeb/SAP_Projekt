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

struct Service {
    let name: String
    let status: String
}

class Parser: NSObject, WKNavigationDelegate {
    
    private let url: URL
    private let webView: WKWebView
    private let callbackHandler: ([Service]) -> Void
    
    init(url: URL, callbackHandler: @escaping ([Service]) -> Void) {
        self.url = url
        self.callbackHandler = callbackHandler
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
    }
    
    func parse() {
        webView.navigationDelegate = self
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let parseFilterUpdateServices : ([String]) -> Void = { serviceStringArray in
            let services = self.findServices(inputArray : serviceStringArray)
            let filteredServices = self.filterServices(unfiltered: services)
            self.updateServicesInTableView(services: filteredServices)
        }
        
        self.getServiceStringArrayFromJS( handleResult: parseFilterUpdateServices)
        
    }
    
    func getServiceStringArrayFromJS( handleResult : @escaping ([String]) -> Void )  {
        webView.evaluateJavaScript("Array.from(document.getElementsByClassName('event')).map ( el => el.innerText )") {
            result, error in
            guard let result = result as? [String] else {
                return
            }
            handleResult(result)
        }
    }
    
    func findServices( inputArray: [String] ) -> [Service] {
        var services: [Service] = []
        inputArray.forEach {
            val in
            let split = val.components(separatedBy: " - ")
            
            if let name = split.first, let status = split.last {
                let service = Service(name: name, status: status)
                services.append(service)
            }
        }
        return services
    }
    
    func filterServices (unfiltered : [Service]) -> [Service] {
        return unfiltered.filter {
            service in
            service.name.lowercased() == "app store" || service.name == "Apple TV"
        }
    }
    
    func updateServicesInTableView( services : [Service]) {
        DispatchQueue.main.async {
            [weak self] in
            self?.callbackHandler(services)
        }
    }
}
