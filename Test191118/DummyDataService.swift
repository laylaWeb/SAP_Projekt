//
//  DummyDataService.swift
//  Test191118
//
//  Created by Sophie Kuna on 08.01.19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation


struct DummyDataService: MainDataService {
    
    
    func getServices() -> [Service] {
        var list: [Service] = [
            Service(name:"service1", status:"not available"),
            Service(name:"service2", status:"not available"),
            Service(name:"service3", status:"available"),
            Service(name:"service4", status:"available"),
            Service(name:"service5", status:"not available")]
        return list
    }
}
