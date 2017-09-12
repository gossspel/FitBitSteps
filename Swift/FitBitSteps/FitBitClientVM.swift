//
//  FitBitClientVM.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/8/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import Foundation

class FitBitClientVM: NSObject {
    let service: ActivityStepDataService
    let activityStepTableCellReuseID: String
    var activityStepTableCellVMs: [ActivityStepTableCellVM]
    let KVOKeyPaths: [String]
    var readyToFetchFromHistory: Bool
    var rowHasTriggeredNetworkCall: [Int: Bool]
    var hasBadRequest: Bool
    
    @objc dynamic var activityStepTableCellVMsUpdated: Bool
    @objc dynamic var hasAuthError: Bool
    @objc dynamic var newStepsAdded: Int
    @objc dynamic var oldStepsAdded: Int
    
    override init() {
        self.service = ActivityStepDataService()
        self.activityStepTableCellReuseID = "ActivityStepTableCell"
        self.activityStepTableCellVMs = FitBitClientVM.getActivityTableCellVMs(FBSCacheManager.shared.DESCSteps)
        self.KVOKeyPaths = ["activityStepTableCellVMsUpdated", "hasAuthError", "newStepsAdded", "oldStepsAdded"]
        self.readyToFetchFromHistory = false
        self.rowHasTriggeredNetworkCall = [:]
        self.hasBadRequest = false
        self.newStepsAdded = 0
        self.oldStepsAdded = 0
        self.activityStepTableCellVMsUpdated = !activityStepTableCellVMs.isEmpty
        self.hasAuthError = fitbitUserId == nil
        super.init()
        
        if let sureUserId = fitbitUserId {
            self.getDESCNewSteps(sureUserId)
        }
    }
    
    class func getActivityTableCellVMs(_ activitySteps: [ActivityStepModel]) -> [ActivityStepTableCellVM] {
        var cellVMs: [ActivityStepTableCellVM] = []
        
        for activityStep in activitySteps {
            cellVMs.append(ActivityStepTableCellVM(activityStep))
        }
        
        return cellVMs
    }
    
    fileprivate func syncCacheAndMemory() {
        if !cacheAndMemoryInSync() {
            activityStepTableCellVMs = FitBitClientVM.getActivityTableCellVMs(FBSCacheManager.shared.DESCSteps)
        }
    }
    
    fileprivate func cacheAndMemoryInSync() -> Bool {
        guard FBSCacheManager.shared.DESCSteps.count == activityStepTableCellVMs.count, !FBSCacheManager.shared.DESCSteps.isEmpty else {
            return false
        }
        
        let latestDateFromCache: String? = FBSCacheManager.shared.DESCSteps[0].date
        let latestDateFromMemory: String? = activityStepTableCellVMs[0].activityStep.date
        let oldestDateFromCache: String? = FBSCacheManager.shared.DESCSteps.last?.date
        let oldestDateFromMemory: String? = activityStepTableCellVMs.last?.activityStep.date
        
        guard let sureLatestDateFromCache = latestDateFromCache, let sureLatestDateFromMemory = latestDateFromMemory else {
            return false
        }
        
        guard let sureOldestDateFromCache = oldestDateFromCache, let sureOldestDateFromMemory = oldestDateFromMemory else {
            return false
        }
        
        return sureLatestDateFromCache == sureLatestDateFromMemory && sureOldestDateFromCache == sureOldestDateFromMemory
    }
    
    
    fileprivate func getNonOverlappingDESCSteps(_ stepsFromResponse: [ActivityStepModel], _ stepsFromCache: [ActivityStepModel], _ stepsNew: Bool) -> [ActivityStepModel] {
        guard !stepsFromCache.isEmpty else {
            return stepsFromResponse
        }
        
        let firstOverlappingStep: ActivityStepModel? = stepsNew ? stepsFromCache[0] : stepsFromCache.last
        
        guard let sureFirstOverlappingStepDateStr = firstOverlappingStep?.date else {
            return stepsFromResponse
        }
        
        for (index, step) in stepsFromResponse.enumerated() {
            if let sureDateStr = step.date, sureDateStr == sureFirstOverlappingStepDateStr {
                if stepsNew {
                    return (index == 0) ? [] : Array(stepsFromResponse[0..<index])
                } else {
                    return index == (stepsFromResponse.count - 1) ? [] : Array(stepsFromResponse[(index + 1)...(stepsFromResponse.count - 1)])
                }
            }
        }
        
        return stepsFromResponse
    }
    
    func updateWithDESCSteps(_ DESCSteps: [ActivityStepModel], _ stepsNew: Bool) {
        
        hasAuthError = false
        
        guard !DESCSteps.isEmpty else {
            return
        }
        
        let nonOverlappingDESCSteps = getNonOverlappingDESCSteps(DESCSteps, FBSCacheManager.shared.DESCSteps, stepsNew)
        
        guard !nonOverlappingDESCSteps.isEmpty else {
            return
        }
        
        let nonOverlappingDESCStepTableCellVMs = FitBitClientVM.getActivityTableCellVMs(nonOverlappingDESCSteps)
        syncCacheAndMemory()
        
        if stepsNew {
            activityStepTableCellVMs = nonOverlappingDESCStepTableCellVMs + activityStepTableCellVMs
            FBSCacheManager.shared.DESCSteps = nonOverlappingDESCSteps + FBSCacheManager.shared.DESCSteps
            
            if nonOverlappingDESCSteps.count == FBSCacheManager.shared.DESCSteps.count {
                activityStepTableCellVMsUpdated = true
            } else {
                newStepsAdded = nonOverlappingDESCSteps.count
            }

        } else {
            activityStepTableCellVMs = activityStepTableCellVMs + nonOverlappingDESCStepTableCellVMs
            FBSCacheManager.shared.DESCSteps = FBSCacheManager.shared.DESCSteps + nonOverlappingDESCSteps
            oldStepsAdded = nonOverlappingDESCSteps.count
        }
        
        readyToFetchFromHistory = true
    }
    
    func updateWithNonSuccessStatusCode(_ statusCode: Int) {
        switch statusCode {
        case 401:
            hasAuthError = true
        case 400:
            hasBadRequest = true
        default:
            break
        }
    }
    
    func getDESCNewSteps(_ userId: String) {
        readyToFetchFromHistory = false
        
        let successHandler: ([ActivityStepModel]) -> Void = { [weak self] (DESCSteps: [ActivityStepModel]) -> Void in
            self?.updateWithDESCSteps(DESCSteps, true)
        }
        
        if FBSCacheManager.shared.DESCSteps.isEmpty {
            service.getList(userId, "today", .thirtyDays, successHandler, updateWithNonSuccessStatusCode)
        } else {
            guard let sureLastUpdatedDateStr = FBSCacheManager.shared.DESCSteps[0].date else {
                return
            }
            
            service.getList(userId, sureLastUpdatedDateStr, "today", successHandler, updateWithNonSuccessStatusCode)
        }
    }
    
    func updateForInfiniteScrolling(_ row: Int) {
        guard activityStepTableCellVMs.count - row == 5, rowHasTriggeredNetworkCall[row] == nil, let sureUserId = fitbitUserId else {
            return
        }
        
        getDESCOldSteps(sureUserId, row)
    }
    
    func getDESCOldSteps(_ userId: String, _ triggeringRow: Int) {
        rowHasTriggeredNetworkCall[triggeringRow] = true
        
        // If we go back far enough, eventutally we will get a HTTP 400 with "Start date cannot be before 2009-01-01"
        guard readyToFetchFromHistory, !hasBadRequest, !FBSCacheManager.shared.DESCSteps.isEmpty else {
            return
        }
        
        guard let sureOldestDateStr = FBSCacheManager.shared.DESCSteps.last?.date else {
            return
        }
        
        let successHandler: ([ActivityStepModel]) -> Void = { [weak self] (DESCSteps: [ActivityStepModel]) -> Void in
            self?.updateWithDESCSteps(DESCSteps, false)
        }
        
        let nonSuccessStatusCodeHandler: (Int) -> Void = { [weak self] (statusCode: Int) -> Void in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.rowHasTriggeredNetworkCall.removeValue(forKey: triggeringRow)
            strongSelf.updateWithNonSuccessStatusCode(statusCode)
        }
        
        service.getList(userId, sureOldestDateStr, .thirtyDays, successHandler, nonSuccessStatusCodeHandler)
    }
}
