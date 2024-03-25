//
//  OperationTask.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIOperation<T: APIResponseProtocol>: APIOperationProtocol {

    // MARK: - Typealias
    typealias Output = T
    typealias DataResponseSuccess = (_ result: Output) -> Void
    typealias DataResponseError = (_ error: APIError) -> Void
    typealias ErrorDialogResponse = (() -> Void)
    typealias OfflineDialogResponse = ((_ tapRetry: Bool) -> Void)
    
    // MARK: - Constants
    struct TaskData {
        var responseQueue: DispatchQueue = .main
        var showIndicator: Bool = true
        var autoShowApiErrorAlert = true
        var autoShowRequestErrorAlert = true
        var didCloseApiErrorDialogHandler: ErrorDialogResponse? = nil
        var didCloseRequestErrorDialogHandler: ErrorDialogResponse? = nil
        var didCloseOfflineDialogHandler: OfflineDialogResponse? = nil
        var successHandler: DataResponseSuccess? = nil
        var failureHandler: DataResponseError? = nil
        init() { }
    }
    
    // MARK: - Variables
    private var taskData = TaskData()
    private var dispatcher: APIDispatcher?
    
    var request: APIRequest?
    
    // MARK: - Init & deinit
    init(request: APIRequest?) {
        self.request = request
        dispatcher = APIDispatcher()
    }
    
    // MARK: - Builder (public)
    @discardableResult
    func set(responseQueue: DispatchQueue) -> APIOperation<Output> {
        taskData.responseQueue = responseQueue
        return self
    }
    
    @discardableResult
    // Load request without: showing indicator + showing api error alert + request error alert automatically
    func set(silentLoad: Bool) -> APIOperation<Output> {
        taskData.showIndicator = !silentLoad
        taskData.autoShowApiErrorAlert = !silentLoad
        taskData.autoShowRequestErrorAlert = !silentLoad
        return self
    }
    
    @discardableResult
    func showIndicator(_ show: Bool) -> APIOperation<Output> {
        taskData.showIndicator = show
        return self
    }
    
    @discardableResult
    func autoShowApiErrorAlert(_ show: Bool) -> APIOperation<Output> {
        taskData.autoShowApiErrorAlert = show
        return self
    }
    
    @discardableResult
    func autoShowRequestErrorAlert(_ show: Bool) -> APIOperation<Output> {
        taskData.autoShowRequestErrorAlert = show
        return self
    }
    
    @discardableResult
    func didCloseApiErrorDialog(_ handler: @escaping ErrorDialogResponse) -> APIOperation<Output> {
        taskData.didCloseApiErrorDialogHandler = handler
        return self
    }
    
    @discardableResult
    func didCloseRequestErrorDialog(_ handler: @escaping ErrorDialogResponse) -> APIOperation<Output> {
        taskData.didCloseRequestErrorDialogHandler = handler
        return self
    }
    
    @discardableResult
    func didCloseOfflineErrorDialog(_ handler: @escaping OfflineDialogResponse) -> APIOperation<Output> {
        taskData.didCloseOfflineDialogHandler = handler
        return self
    }
    
    // MARK: - Executing functions (public)
    @discardableResult
    func execute(target: UIViewController? = nil, success: DataResponseSuccess? = nil, failure: DataResponseError? = nil) -> APIOperation<Output> {
        func run(queue: DispatchQueue?, body: @escaping () -> Void) {
            (queue ?? .main).async {
                body()
            }
        }
        dispatcher?.target = target
        taskData.successHandler = success
        taskData.failureHandler = failure
        let showIndicator = taskData.showIndicator
        let responseQueue = taskData.responseQueue
        if let request = self.request {
            if showIndicator {
                run(queue: .main) { APIUIIndicator.showIndicator() }
            }
            // Print information of request
            request.printInformation()
            print("▶︎ [\(request.name)] is requesting...")
            
            // Execute request
            dispatcher?.execute(request: request, completed: { response in
                if showIndicator {
                    run(queue: .main) { APIUIIndicator.hideIndicator() }
                }
                switch response {
                case .success(let json):
                    print("▶︎ [\(request.name)] succeed !")
                    run(queue: responseQueue) {
                        self.callbackSuccess(output: T(json: json))
                    }
                case .error(let error):
                    print("▶︎ [\(request.name)] error message: \"\(error.message ?? "empty")\"")
                    if error.message == "トークンが必要です" {
                       // AppEnvironment.instance.logoutTaskExecute()
                    }
                    if request.name == "API verify receipt" {
                        self.taskData.failureHandler?(error)
                    }
                    run(queue: responseQueue) {
                        self.callbackError(error: error)
                    }
                }
            })
        } else {
            run(queue: responseQueue) {
                self.callbackError(error: APIError.unknown)
            }
        }
        return self
    }
    
    func cancel() {
        dispatcher?.cancel()
    }
    
    // MARK: - Handle callback with input data
    private func callbackSuccess(output: T) {
        taskData.successHandler?(output)
    }
    
    private func callbackError(error: APIError) {
       self.showErrorAlertIfNeeded(error: error)
    }
    
    private func resetSchoolCodeLogout(errorString: String) {
//        CustomMenuAlertVC(usingOneButton: true,
//                          topButtonTitle: "OK",
//                          message: errorString,
//                          imageString: "icon_flat_attention",
//                          onTopButtonClick: {
//                            AppEnvironment.instance.logoutTaskExecute()
//        }).showDialog()
    }
    
    // MARK: - Alerts
    private func showErrorAlertIfNeeded(error: APIError) {
        switch error {
        case .api:
            guard taskData.autoShowApiErrorAlert else {
                taskData.failureHandler?(error)
                return
            }
            
            guard error.errors == nil else {
                if let _ = error.errors?["school_code_reset"].arrayValue.first?.string {
                    if let topController = UIApplication.topViewController(), topController.name != "SFAuthenticationViewController" {
                        //MARK: Remove this logic later
//                        if let loginData = AppEnvironment.instance.loginData, loginData.isPurchased == false {
//                            Utils.showInsertCode()
//                        }
                    }
                    taskData.failureHandler?(error)
                    return
                } else if let logoutCommand = error.errors?["invalid_token"].bool, logoutCommand {
                    resetSchoolCodeLogout(errorString: error.message ?? "")
                    return
                } else {
                    taskData.failureHandler?(error)
                    return
                }
            }
            if error.apiCode == 504 {
                //AppDelegate.shared.showAlertUpdateApp()
            } else {
                APIUIAlert.showApiErrorDialogWith(error: error, completion: {
                    self.taskData.didCloseApiErrorDialogHandler?()
                })
            }
            taskData.failureHandler?(error)
        case .request(_, let requestError):
            guard taskData.autoShowRequestErrorAlert, let requestError = requestError else {
                taskData.failureHandler?(error)
                return
            }
            if requestError.isInternetOffline {
                APIUIAlert.showOfflineErrorDialog(completion: { index, tapRetry in
                    if tapRetry {
                        self.execute(target: self.dispatcher?.target,
                                     success: self.taskData.successHandler,
                                     failure: self.taskData.failureHandler)
                    }
                })
            } else {
                APIUIAlert.showRequestErrorDialogWith(error: error, completion: {
                    self.taskData.didCloseRequestErrorDialogHandler?()
                })
            }
        }
    }
}
