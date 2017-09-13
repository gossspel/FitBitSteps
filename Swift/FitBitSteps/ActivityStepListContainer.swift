//
//  LogStepListContainer.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/8/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import Foundation
import ObjectMapper

class ActivityStepListContainer: Mappable {
    var activitySteps: [ActivityStepModel]?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        activitySteps <- map["activities-steps"]
    }
}
