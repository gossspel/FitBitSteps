//
//  LogStepModel.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/8/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import Foundation
import ObjectMapper

class ActivityStepModel: Mappable {
    var date: String?
    var value: String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        date    <- map["dateTime"]
        value   <- map["value"]
    }
}
