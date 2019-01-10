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
   
    
    
    func getServices() -> [Service] {
        let myUrl = "https://status.aws.amazon.com/"
        
        Alamofire.request(myUrl, method: .get, parameters:nil, encoding: URLEncoding.default).validate(contentType: ["application/x-www-form-urlencoded"]).response { (response) in
            if let data = response.data, let html = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    let rows = try doc.select("#EU_block > table:nth-child(1) > tbody > tr")
                    //guard let result = response as? [String] else { return }
                    
                    for element in rows.array() {
                        var results = try element.children().text()
                        print(results)
                        //var resultsString = String(results)
                    }
                    
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
}
