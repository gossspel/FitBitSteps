//
//  ActivityStepTableCellVM.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/8/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import Foundation

class ActivityStepTableCellVM: NSObject {
    var activityStep: ActivityStepModel
    
    @objc dynamic var stepLabelText: String
    @objc dynamic var dateLabelText: String
    
    init(_ activityStep: ActivityStepModel) {
        self.activityStep = activityStep
        self.stepLabelText = ActivityStepTableCellVM.getStepLabelText(activityStep.value ?? "")
        self.dateLabelText = ActivityStepTableCellVM.getDateLabelText(activityStep.date ?? "")
        super.init()
    }
    
    class func getStepLabelText(_ stepStr: String) -> String {
        var quantifier: String = "steps"
        
        if stepStr == "1" {
            quantifier = "step"
        }
        
        return "\(stepStr) \(quantifier)"
    }
    
    class func getDateLabelText(_ dateStr: String) -> String {
        let date: Date? = Date.getDateFromDateStr(dateStr, .dashYMD)
        
        guard let sureDate = date else {
            return dateStr
        }
        
        let diff: Int = Int(Date().timeIntervalSince(sureDate))
        
        if diff < 3600 * 24 {
            return "Today"
        } else if diff < 3600 * 48 {
            return "Yesterday"
        } else {
            return Date.getDateStrFromDate(sureDate, .slashMDY)
        }
    }
}
