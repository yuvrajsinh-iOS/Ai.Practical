
import Foundation

enum AIResult {
    case success(AIResponse)
    case failure(WebError)

    /// Returns `true` if the result is a success, `false` otherwise.
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    /// Returns `true` if the result is a failure, `false` otherwise.
    var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    var response: AIResponse? {
        switch self {
        case .success(let responseData):
            return responseData
        case .failure:
            return nil
        }
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    var error: WebError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

extension AIResult: CustomDebugStringConvertible {
    /// The debug textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure in addition to the value or error.
    var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}
