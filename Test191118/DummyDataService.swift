//
//  DummyDataService.swift
//  Test191118
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
            Service(name:"App Store", status: randomStatusBlue()),
            Service(name:"Device Enrollment Program", status: randomStatusRed()),
            Service(name:"iOS Device Activation", status: randomStatusBlue()),
            Service(name:"Mac App Store", status: randomStatusRed()),
            Service(name:"macOS Software Update", status: randomStatusRed()),
            Service(name:"Volume Purchase Program", status: randomStatusRed())])
    }
    
    func randomStatusRed() -> String {
        if Int.random(in: 0...1) == 0 {
            return "service available"
        } else {
            return "service disruption"
        }
    }
    
    func randomStatusBlue() -> String {
        if Int.random(in: 0...1) == 0 {
            return "service available"
        } else {
            return "service maintenance"
        }
    }
}
