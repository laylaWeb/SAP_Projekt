//
//  DummyDataService.swift
//  CSW
//
//  Created by Sophie Kuna on 08.01.19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation


struct DummyDataService: MainDataService {
    
    private let callbackHandler: ([Service]) -> Void
    
    init(callbackHandler: @escaping ([Service]) -> Void) {
        self.callbackHandler = callbackHandler
    }
    
    func getServices() {
        self.callbackHandler([
            Service(name:"App Store", status: randomStatus()),
            Service(name:"Device Enrollment Program", status: randomStatus()),
            Service(name:"iOS Device Activation", status: randomStatus()),
            Service(name:"Mac App Store", status: randomStatus()),
            Service(name:"macOS Software Update", status: randomStatus()),
            Service(name:"Volume Purchase Program", status: randomStatus())])
    }
    
    func randomStatus() -> String {
        if Int.random(in: 0...1) == 0 {
            return "available"
        } else {
            return "not available"
        }
    }
}
