
import Alamofire
import Foundation
import SwiftyJSON

enum WebError: Error {

    /// Throws when server don't give any response
    case noData

    /// Throws when internet isn't connected
    case noInternet

    /// Throws when server is down because of any reason
    case hostFail

    /// Throws when response is not as per predefined json format
    case parseFail

    /// Throws when request timeout occurs
    case timeout

    /// Throws when server unauthorise user
    case unAuthorise

    /// Throws when application cancel running request
    case cancel

    /// Throws when error is none of the above
    case unknown
}

class AIWebservice: SessionManager {

    typealias ResultEvent = ((AIResult)->Void)
    typealias ResponseEvent = ((AIResponse?)->Void)?

    // Custom header field
    var header = [
        "Content-Type":"application/json"
    ]

    static let API: AIWebservice = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 120
        configuration.timeoutIntervalForRequest  = 120

        var webService = AIWebservice(configuration: configuration)
        //webService.startRequestsImmediately = false
        return webService
    }()

    /// Set Bearer Token here
    ///
    /// - parameter token: string without bearer prefix for `token`
    func set(authorizeToken token: String?) {
        header["accesstoken"] = token!
    }

    /// Remove Bearer token with this method
    func removeAuthorizeToken() {
        header.removeValue(forKey: "accesstoken")
    }

    func cancelAllTasks() {
        self.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }

    //All webservices of this application by pass from this method
    @discardableResult
    func sendRequest(_ route: Router, query: String = "",completion: ResultEvent? = nil) -> DataRequest? {
        guard Util.isReachable == true else {
            completion?(.failure(.noInternet))
            return nil
        }
        var path = route.path + query
        path = path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed) ?? ""
        
        var parameter = route.parameters
        if parameter == nil {
            parameter = [:]
        }

        var encoding: ParameterEncoding = JSONEncoding.default
        if route.method == .get {
            encoding = URLEncoding.default
        }

        let request = self.request(path, method: route.method, parameters: parameter!, encoding: encoding, headers: header)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if let _ = response.result.value {
                    let jsonResult: JSON = JSON(response.result.value!)
                    guard jsonResult.type != .null else {
                        completion?(.failure(.parseFail))
                        return
                    }
                    print(jsonResult)
                    let resp = AIResponse(parameter: jsonResult, dataKey: route.dataKey)
                    completion?(.success(resp))
                } else {
                    completion?(.failure(.noData))
                }
            case .failure(let error):
                print("Error: \(error)")
                if error._code == NSURLErrorTimedOut {//
                    completion?(.failure(.timeout))
                } else if error._code == NSURLErrorCannotConnectToHost {
                    completion?(.failure(.hostFail))//
                } else if error._code == NSURLErrorCancelled {
                    completion?(.failure(.cancel))
                } else if error._code == NSURLErrorNetworkConnectionLost {
                    if Util.isReachable == true {
                        //Slow Internet connection
                    } else {
                        //Internet disconnected before completion of request
                    }
                    completion?(.failure(.unknown))
                } else {//
                    completion?(.failure(.unknown))
                }
            }
        }
        return request
    }
}

