import XCTest
@testable import TrendFlicks
final class TrendFlicksHttpCodes: XCTestCase {
  func testErrorCodeValues() {
    XCTAssertEqual(HTTPErrorCode.success.code, 200)
    XCTAssertEqual(HTTPErrorCode.invalidURL.code, 4000)
    XCTAssertEqual(HTTPErrorCode.invalidStatusCode.code, 9999)
    XCTAssertEqual(HTTPErrorCode.authenticationFailed.code, 401)
    XCTAssertEqual(HTTPErrorCode.invalidApiKey.code, 401)
    XCTAssertEqual(HTTPErrorCode.invalidService.code, 501)
  }

  func testErrorMessageValues() {
    XCTAssertEqual(HTTPErrorCode.success.message, " 200 OK")
    XCTAssertEqual(HTTPErrorCode.invalidURL.message, "4000 Invalid URL")
    XCTAssertEqual(HTTPErrorCode.invalidStatusCode.message, "9999 Invalid statue code")
    XCTAssertEqual(HTTPErrorCode.authenticationFailed.message, "401 Authentication failed")
    XCTAssertEqual(HTTPErrorCode.invalidApiKey.message, "401 Invalid API key")
    XCTAssertEqual(HTTPErrorCode.invalidService.message, "501 Invalid service")
  }
}
