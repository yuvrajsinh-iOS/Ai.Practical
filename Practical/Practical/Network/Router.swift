
import Alamofire
import Foundation
import SwiftyJSON

protocol Routable {
    var path        : String { get }
    var method      : HTTPMethod { get }
    var parameters  : Parameters? { get }
    var dataKey     : String? { get }
}

enum Router: Routable, Equatable {
    case userList
    
    static func ==(lhs: Router, rhs: Router) -> Bool {
        return lhs.path == rhs.path
    }
}

extension Router {
    var path: String {
        switch self {
        case .userList:
            return "https://sd2-hiring.herokuapp.com/api/users?limit=10&offset="
        }
    }
}

extension Router {
    var method: HTTPMethod {
        switch self {
        case .userList:
            return .get
        }
    }
}

extension Router {
    var parameters: Parameters? {
        switch self {
        case .userList:
            return nil
        }
    }
}

extension Router {
    var dataKey: String? {
        switch self {
        case .userList:
            return nil
        }
    }
}
