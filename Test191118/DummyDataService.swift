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
            newService(name:"App Store"),
            newService(name:"Device Enrollment Program"),
            newService(name:"iOS Device Activation"),
            newService(name:"Mac App Store"),
            newService(name:"macOS Software Update"),
            newService(name:"Volume Purchase Program")])
    }
    
    func randomStatus() -> (ServiceState, String) {
        let random = Int.random(in: 0...2)
        if random == 0 {
            return (ServiceState.Available, "service available")
        } else if random == 1 {
            return (ServiceState.Unavailable, "service disruption")
        } else {
            return (ServiceState.Maintenance, "service maintenance")
        }
    }
    
    
    func newService(name: String) -> Service {
        let (state, stateMessage) = randomStatus()
        return Service(name: name, stateMessage: stateMessage, state: state)
    }
}
