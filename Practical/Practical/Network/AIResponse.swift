import Foundation
import SwiftyJSON

struct AIResponse {
    var status      : Bool!
    var statusCode  : Int!
    var message     : String!
    var data        : Any!
 
    init() {
        status     = false
        message    = ""
        statusCode = 1
        data       = nil
    }

    init(parameter: JSON, dataKey: String?) {
        status     = parameter["status"].boolValue
        message    = parameter["message"].stringValue
        statusCode = parameter["statusCode"].intValue
        data = parameter
    }
    
    static var noInternetResponse: AIResponse {
        var response        = AIResponse()
        response.status     = false
        response.statusCode = 502
        response.message    = "Internet connection is not available"
        response.data       = nil
        return response
    }
}
