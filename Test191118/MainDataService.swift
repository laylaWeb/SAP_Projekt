//
//  MainDataService.swift
//  Test191118
//
//  Created by Sophie Kuna on 08.01.19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation

protocol MainDataService {
    func getServices(callbackHandler: @escaping ([Service]) -> Void)
}
