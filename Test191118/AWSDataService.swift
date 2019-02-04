//
//  AWSDataService.swift
//  Test191118
//
//  Created by Sophie Kuna on 08.01.19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation
import WebKit
import Alamofire
import SwiftSoup

struct AWSDataService: MainDataService {
    
    private let callbackHandler: ([Service]) -> Void
    
    init(callbackHandler: @escaping ([Service]) -> Void) {
        self.callbackHandler = callbackHandler
    }
   
    func getServices() {
        let myUrl = "https://status.aws.amazon.com/"
        
        AF.request(myUrl, method: .get, parameters:nil, encoding: URLEncoding.default)
            .validate(contentType: ["application/x-www-form-urlencoded"])
            .response { (response) in
            if let data = response.data, let html = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    let rows = try doc.select("#EU_block > table:nth-child(1) > tbody > tr")
                    
                    if case try rows.first()?.children().get(1).text() = "No recent events." {
                        var services: [Service] = []
                        for element in rows.array() {
                            let stateMessage = try element.children().get(1).text()
                            let serviceState = AWSDataService.evaluateState(stateMessage: stateMessage)
                            services.append(Service(name:"Region Europe", stateMessage: stateMessage, state:serviceState))
                        }
                        self.callbackHandler(services)
                    } else {
                        var services: [Service] = []
                        for element in rows.array() {
                            let name = try element.children().get(1).text()
                            let stateMessage = try element.children().get(2).text()
                            let serviceState = AWSDataService.evaluateState(stateMessage: stateMessage)
                            services.append(Service(name: name, stateMessage: stateMessage, state:serviceState))
                        }
                        self.callbackHandler(services)
                    }
                   
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    static func evaluateState(stateMessage: String) -> ServiceState {
        // TODO: Assert other states
        if stateMessage == "No recent events." {
            return ServiceState.Available
        } else if stateMessage.contains("RESOLVED") {
            return ServiceState.Available
        } else {
            return ServiceState.Unavailable
        }
    }
    
}
