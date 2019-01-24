//
//  AppleDataService.swift
//  Test191118
//
//  Created by Sophie Kuna on 24.01.19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation

class AppleDataService: MainDataService {
    private let parser: Parser
    
    init(callbackHandler: @escaping ([Service]) -> Void) {
        self.parser = Parser(callbackHandler: callbackHandler)
    }
    
    func getServices() {
        parser.parse()
    }
}
