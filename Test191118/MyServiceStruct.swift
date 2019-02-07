//
//  MyServiceStruct.swift
//  Test191118
//
//  Created by Sophie Kuna on 07.02.19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation

struct Service {
    var name: String
    var stateMessage: String
    var state: ServiceState
}

enum ServiceState {
    case Available
    case Unavailable
    case Maintenance
    case Unknown
}
