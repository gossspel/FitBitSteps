//
//  FBSHTTPManager.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/8/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import Foundation
import Alamofire

enum FBSHTTPBodyContentType: String {
    case JSON = "application/json"
    case URLEncoded = "application/x-www-form-urlencoded"
}

protocol FBSHTTPMangerProtocol: AnyObject {
    func sendHTTPGETRequest(
        _ URLStr: String,
        _ headers: [String: String]?,
        _ queryStringParams: [String: Any]?,
        _ JSONHandler: @escaping (String) -> Void,
        _ nonSuccessStatusCodeHandler: ((Int) -> Void)?
        ) -> Void
    
    func sendHTTPPOSTRequest(
        _ URLStr: String,
        _ headers: [String: String]?,
        _ HTTPBodyParams: [String: Any]?,
        _ HTTPBodyContentType: FBSHTTPBodyContentType,
        _ JSONHandler: @escaping (String) -> Void,
        _ nonSuccessStatusCodeHandler: ((Int) -> Void)?
        ) -> Void
}

class MSAlamofireHTTPManager: FBSHTTPMangerProtocol {
    func sendHTTPGETRequest(
        _ URLStr: String,
        _ headers: [String : String]?,
        _ queryStringParams: [String : Any]?,
        _ JSONHandler: @escaping (String) -> Void,
        _ nonSuccessStatusCodeHandler: ((Int) -> Void)?)
    {
        self.sendHTTPRequest(.get, URLStr, headers, queryStringParams, URLEncoding.queryString, JSONHandler, nonSuccessStatusCodeHandler)
    }
    
    func sendHTTPPOSTRequest(
        _ URLStr: String,
        _ headers: [String : String]?,
        _ HTTPBodyParams: [String : Any]?,
        _ HTTPBodyContentType: FBSHTTPBodyContentType,
        _ JSONHandler: @escaping (String) -> Void,
        _ nonSuccessStatusCodeHandler: ((Int) -> Void)?)
    {
        var paramsEncoding: ParameterEncoding
        
        switch HTTPBodyContentType {
        case .JSON:
            paramsEncoding = JSONEncoding.default
        case .URLEncoded:
            paramsEncoding = URLEncoding.default
        }
        
        self.sendHTTPRequest(.put, URLStr, headers, HTTPBodyParams, paramsEncoding, JSONHandler, nonSuccessStatusCodeHandler)
    }
    
    fileprivate func sendHTTPRequest(
        _ method: HTTPMethod,
        _ URLStr: String,
        _ headers: [String : String]?,
        _ params: [String : Any]?,
        _ paramsEncoding: ParameterEncoding,
        _ JSONHandler: @escaping (String) -> Void,
        _ nonSuccessStatusCodeHandler: ((Int) -> Void)?)
    {
        Alamofire.request(
            URLStr,
            method: method,
            parameters: params,
            encoding: paramsEncoding,
            headers: headers
            ).responseString(completionHandler: { (data: DataResponse<String>) in
                switch data.result {
                case .success:
                    guard let statusCode = data.response?.statusCode, let jsonStr = data.result.value else {
                        return
                    }
                    
                    if 200...299 ~= statusCode {
                        JSONHandler(jsonStr)
                    } else {
                        nonSuccessStatusCodeHandler?(statusCode)
                    }
                case .failure:
                    break
                }
            })
    }
}
