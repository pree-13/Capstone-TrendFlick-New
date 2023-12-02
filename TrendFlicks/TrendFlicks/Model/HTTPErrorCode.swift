import Foundation

enum HTTPErrorCode: Error, CaseIterable {
  case success
  case invalidURL
  case invalidStatusCode
  case authenticationFailed
  case invalidService
  case invalidApiKey

  var code: Int {
    switch self {
    case .success:
      return 200
    case .invalidURL:
      return 4000
    case .invalidStatusCode:
      return 9999
    case .authenticationFailed:
      return 401
    case .invalidApiKey:
      return 401
    case .invalidService:
      return 501
    }
  }

  var message: String {
    switch self {
    case .success:
      return " 200 OK"
    case .invalidURL:
      return "4000 Invalid URL"
    case .invalidStatusCode:
      return "9999 Invalid statue code"
    case .authenticationFailed:
      return "401 Authentication failed"
    case .invalidApiKey:
      return "401 Invalid API key"
    case .invalidService:
      return "501 Invalid service"
    }
  }
}
