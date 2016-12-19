import XCTest
@testable import Differences

class DifferencesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Differences().text, "Hello, World!")
    }


    static var allTests : [(String, (DifferencesTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
