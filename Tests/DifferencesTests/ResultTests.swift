import XCTest
@testable import Differences

class ResultTests: XCTestCase {
    static var allTests : [(String, (ResultTests) -> () throws -> Void)] {
        return [
            ("testGetDeletesUpdatesInsertsMovesAndChanges", testGetDeletesUpdatesInsertsMovesAndChanges),
            ("testCount", testCount),
            ("testHasUpdates", testHasUpdates),
            ("testInsertDifference", testInsertDifference),
        ]
    }

    func testGetDeletesUpdatesInsertsMovesAndChanges() {
        let deletes = [Difference.delete(0), Difference.delete(3)]
        let updates = [Difference.update(1)]
        let inserts = [Difference.insert(4), Difference.insert(5), Difference.insert(123)]
        let moves = [Difference.move(124, 52), Difference.move(21, 20)]
        let differences = deletes + updates + inserts + moves
        let result = Result(differences: differences, old: Dictionary<String, Int>(), new: Dictionary<String, Int>())
        XCTAssertEqual(Set(deletes), Set(result.deletes))
        XCTAssertEqual(Set(updates), Set(result.updates))
        XCTAssertEqual(Set(inserts), Set(result.inserts))
        XCTAssertEqual(Set(moves), Set(result.moves))
        XCTAssertEqual(Set(differences), Set(result.changes))
    }

    func testCount() {

    }

    func testHasUpdates() {

    }

    func testInsertDifference() {
        
    }
}
