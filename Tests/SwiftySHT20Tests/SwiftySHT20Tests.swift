import XCTest
@testable import SwiftySHT20

final class SwiftySHT20Tests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftySHT20().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
