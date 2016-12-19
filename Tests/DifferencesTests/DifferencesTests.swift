import XCTest
@testable import Differences

class DifferencesTests: XCTestCase {
    static var allTests : [(String, (DifferencesTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }

    func testExample() {
        let old = [0, 1, 2]
        let new = [2, 1, 3]

        XCTAssertEqual([Difference.update(0)], old.differences(to: new))
        XCTAssertEqual([Difference.update(0)], new.differences(from: old))
    }
}
