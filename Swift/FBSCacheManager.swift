//
//  FBSCacheManager.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/10/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import Foundation

class FBSCacheManager {
    static let shared = FBSCacheManager()
    var DESCSteps: [ActivityStepModel]
    
    private init() {
        self.DESCSteps = []
    }
}
