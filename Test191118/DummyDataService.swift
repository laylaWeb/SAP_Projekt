//
//  DummyDataService.swift
//  Test191118
//
//  Created by Sophie Kuna on 08.01.19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation


struct DummyDataService: MainDataService {
    
    func getServices(callbackHandler: @escaping ([Service]) -> Void) {
        callbackHandler([
            Service(name:"App Store", status:"not available"),
            Service(name:"Device Enrollment Program", status:"available"),
            Service(name:"iOS Device Activation", status:"available"),
            Service(name:"Mac App Store", status:"available"),
            Service(name:"macOS Software Update", status:"available"),
            Service(name:"Volume Purchase Program", status:"available")])
    }
}
