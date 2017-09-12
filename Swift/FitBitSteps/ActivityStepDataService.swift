//
//  ActivityStepDataService.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/8/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import Foundation
import ObjectMapper

// Documentation: https://dev.fitbit.com/reference/web-api/activity/

enum Period: String {
    case ondDay = "1d"
    case sevenDays = "7d"
    case thirtyDays = "30d"
    case oneWeek = "1w"
    case oneMonth = "1m"
    case threeMonths = "3m"
    case sixMonths = "6m"
    case oneYear = "1y"
}

class ActivityStepDataService {
    let baseGETListURLStr: String
    let activityURI: String
    let GETListMapper: Mapper<ActivityStepListContainer>
    
    init() {
        self.baseGETListURLStr = "https://api.fitbit.com/1/user"
        self.activityURI = "activities/steps/date"
        self.GETListMapper = Mapper<ActivityStepListContainer>()
    }
    
    fileprivate func getCompleteURLStr(_ userId: String, _ endDate: String, _ period: Period) -> String {
        return "\(baseGETListURLStr)/\(userId)/\(activityURI)/\(endDate)/\(period.rawValue).json"
    }
    
    fileprivate func getCompleteURLStr(_ userId: String, _ startDate: String, _ endDate: String) -> String {
        return "\(baseGETListURLStr)/\(userId)/\(activityURI)/\(startDate)/\(endDate).json"
    }
    
    fileprivate func getList(
        _ completeURLStr: String,
        _ successHander: @escaping ([ActivityStepModel]) -> Void,
        _ nonSuccessStatusCodeHandler: ((Int) -> Void)?)
    {
        FBSAPIClient.shared.sendHTTPGETRequest(completeURLStr, nil, nil, { [weak self] (JSONStr: String) -> Void in
            guard let sureResponseModel = self?.GETListMapper.map(JSONString: JSONStr) else {
                return
            }
            
            let ASCSteps: [ActivityStepModel] = sureResponseModel.activitySteps ?? []
            let DESCSteps: [ActivityStepModel] = Array(ASCSteps.reversed())
            
            successHander(DESCSteps)
        }, nonSuccessStatusCodeHandler)
    }
    
    func getList(
        _ userId: String,
        _ endDate: String,
        _ period: Period,
        _ successHander: @escaping ([ActivityStepModel]) -> Void,
        _ nonSuccessStatusCodeHandler: ((Int) -> Void)?)
    {
        let completeURLStr: String = self.getCompleteURLStr(userId, endDate, period)
        self.getList(completeURLStr, successHander, nonSuccessStatusCodeHandler)
    }
    
    func getList(
        _ userId: String,
        _ startDate: String,
        _ endDate: String,
        _ successHander: @escaping ([ActivityStepModel]) -> Void,
        _ nonSuccessStatusCodeHandler: ((Int) -> Void)?)
    {
        let completeURLStr: String = self.getCompleteURLStr(userId, startDate, endDate)
        self.getList(completeURLStr, successHander, nonSuccessStatusCodeHandler)
    }
}
