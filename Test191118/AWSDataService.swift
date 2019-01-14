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
   
    func getServices(callbackHandler: @escaping ([Service]) -> Void) {
        let myUrl = "https://status.aws.amazon.com/"
        
        AF.request(myUrl, method: .get, parameters:nil, encoding: URLEncoding.default)
            .validate(contentType: ["application/x-www-form-urlencoded"])
            .response { (response) in
            if let data = response.data, let html = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    let rows = try doc.select("#EU_block > table:nth-child(1) > tbody > tr")
                    
                    if case try rows.first()?.children().get(1).text() = "No recent events." {
                        callbackHandler([])
                    } else {
                        var services: [Service] = []
                        for element in rows.array() {
                            let name = try element.children().get(1).text()
                            let status = try element.children().get(2).text()
                            services.append(Service(name: name, status: status))
                        }
                        callbackHandler(services)
                    }
                   
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
}
