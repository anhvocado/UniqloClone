//
//  MainEnviroment.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 2/18/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIMainEnviroment: APIEnviromentProtocol {
    
    var baseUrl: String {
        #if DEVELOP
        if let baseUrl = ProcessInfo.processInfo.environment["BASEURL"] {
            return "\(baseUrl)/api"
        }
        return "http://videoapp.rikkei.org/api"
        #elseif STAGING
        return "https://stg.tenorino.app/api"
        #else
        return "https://tenorino.app/api"
        #endif
    }
    
    var baseUrlV2: String {
        return baseUrl + "/v2"
    }
    
    var baseUrlV3: String {
        return baseUrl + "/v3"
    }
    
    var version: String {
        return "/v2"
    }
    
    var headers: HTTPHeaders {
        return [
            "User-Agent": ""
        ]
    }
    
    var encoding: ParameterEncoding = URLEncoding.default
    
    var timeout: TimeInterval {
        return 30
    }
    
    func parseApiErrorJson(_ json: JSON, statusCode: Int?) -> APIError? {
        // Try to parse input json to error class according to your error json format
        // Example:
         guard let success = json["status_code"].int else { return APIError.request(statusCode: statusCode, error: nil) }
               if success == 200 {  return nil }
               let errorMessage = json["message"].string
               let messageCode = json["status_code"].int
               let errorData = json["errors"]
        return APIError.api(statusCode: statusCode,
                            apiCode: messageCode,
                            message: errorMessage, errors: errorData)
    }
}
