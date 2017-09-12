//
//  FBSAPIClient.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/8/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import Foundation

class FBSAPIClient {
    static let shared = FBSAPIClient()
    let httpManager: FBSHTTPMangerProtocol
    
    private init() {
        self.httpManager = MSAlamofireHTTPManager()
    }
    
    func sendHTTPGETRequest(
        _ URLStr: String,
        _ headers: [String : String]?,
        _ queryStringParams: [String : Any]?,
        _ JSONHandler: @escaping (String) -> Void,
        _ nonSuccessStatusCodeHandler: ((Int) -> Void)?)
    {
        let authorizedHeaders = getAuthorizedHeaders(headers)
        httpManager.sendHTTPGETRequest(URLStr, authorizedHeaders, queryStringParams, JSONHandler, nonSuccessStatusCodeHandler)
    }
    
    func sendHTTPPOSTRequest(
        _ URLStr: String,
        _ headers: [String : String]?,
        _ HTTPBodyParams: [String : Any]?,
        _ HTTPBodyContentType: FBSHTTPBodyContentType,
        _ JSONHandler: @escaping (String) -> Void,
        _ nonSuccessStatusCodeHandler: ((Int) -> Void)?)
    {
        let authorizedHeaders = getAuthorizedHeaders(headers)
        httpManager.sendHTTPPOSTRequest(URLStr, authorizedHeaders, HTTPBodyParams, HTTPBodyContentType, JSONHandler, nonSuccessStatusCodeHandler)
    }
    
    fileprivate func getAuthorizedHeaders(_ headers: [String : String]?) -> [String : String] {
        var authorizedHeaders: [String: String] = [:]
        
        if let sureHeaders = headers {
            authorizedHeaders = sureHeaders
        }
        
        if let sureToken = fitbitAccessToken {
            authorizedHeaders["Authorization"] = "Bearer \(sureToken)"
        }
        
        return authorizedHeaders
    }
}
