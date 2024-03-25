//
//  ErrorExtension.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

public enum APIError {
    case api(statusCode: Int?, apiCode: Int?, message: String?, errors: JSON? = nil)
    case request(statusCode: Int?, error: Error?)
    
    var apiCode: Int? {
        switch self {
        case .api(_, let apiCode, _, _):
            return apiCode
        default:
            return nil
        }
    }
    
    var statusCode: Int? {
        switch self {
        case .api(let statusCode, _, _, _):
            return statusCode
        case .request(let statusCode, _):
            return statusCode
        }
    }
    
    var errors: JSON? {
        switch self {
        case .api(_, _, _, let data):
            if let data = data, data.exists() {
                return data
            }
            return nil
        case .request(_, _):
            return nil
        }
    }
    
    var message: String? {
        switch self {
        case .api(_, _, let message, _):
            return message
        case .request(_, let error):
            guard let error = error else {
                return "エラーが発生しました。しばらくしてからもう一度お試しください。"
            }
            if error.isHostConnectFailed {
                return "サーバーに接続できません"
            } else if error.isNetworkConnectionLost || error.isInternetOffline {
                return "ロード中にサーバー接続が切断されました。"
            } else if error.isTimeout {
                return "サーバーへの接続がタイムアウトしました"
            } else if error.isBadServerResponse {
                return "サーバーからのデータはありません"
            } else {
                return "エラーが発生しました。しばらくしてからもう一度お試しください。"
            }
        }
    }
    
    // Create an unknown api error
    static var unknown: APIError {
        return APIError.request(statusCode: nil, error: nil)
    }
}
