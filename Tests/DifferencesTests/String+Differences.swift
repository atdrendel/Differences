import XCTest
@testable import Differences

class String_Differences: XCTestCase {
    static var allTests : [(String, (String_Differences) -> () throws -> Void)] {
        return [
            ("testInsertAtStart", testInsertAtStart),
        ]
    }

    func testInsertAtStart() {
        let old = "Test"
        let new = "ReTest"
        let expected: Array<Difference> = [.insert(0), .insert(3), .move(0, 2)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    // MARK: Helpers
    private func _assert(
        expected: Array<Difference>,
        equalsOld old: String,
        diffedWithNew new: String) {
        let toNewDiffs = old.differences(to: new)
        let fromOldDiffs = new.differences(from: old)
        XCTAssertEqual(expected.count > 0, toNewDiffs.hasChanges)
        XCTAssertEqual(expected.count > 0, fromOldDiffs.hasChanges)
        XCTAssertEqual(expected.count, toNewDiffs.count)
        XCTAssertEqual(expected.count, fromOldDiffs.count)
        XCTAssertEqual(Set(expected), Set(toNewDiffs.changes))
        XCTAssertEqual(Set(expected), Set(fromOldDiffs.changes))
    }
}
