import XCTest
@testable import Differences

class ResultTests: XCTestCase {
    static var allTests : [(String, (ResultTests) -> () throws -> Void)] {
        return [
            ("testGetDeletesUpdatesInsertsMovesAndChanges", testGetDeletesUpdatesInsertsMovesAndChanges),
            ("testInsertDifference", testInsertDifference),
            ("testHasUpdates", testHasUpdates),
            ("testCount", testCount),
            ("testCollectionViewDifferences1", testCollectionViewDifferences1),
            ("testCollectionViewDifferences2", testCollectionViewDifferences2),
        ]
    }

    func testGetDeletesUpdatesInsertsMovesAndChanges() {
        let deletes = [Difference.delete(0), Difference.delete(3)]
        let updates = [Difference.update(1)]
        let inserts = [Difference.insert(4), Difference.insert(5), Difference.insert(123)]
        let moves = [Difference.move(124, 52), Difference.move(21, 20)]
        let differences = deletes + updates + inserts + moves
        let result = Result(differences: differences)
        XCTAssertEqual(Set(deletes), Set(result.deletes))
        XCTAssertEqual(Set(updates), Set(result.updates))
        XCTAssertEqual(Set(inserts), Set(result.inserts))
        XCTAssertEqual(Set(moves), Set(result.moves))
        XCTAssertEqual(Set(differences), Set(result.changes))
    }

    func testInsertDifference() {
        var result = Result()
        XCTAssertTrue(result.changes.isEmpty)

        let delete = Difference.delete(0)
        result.insert(delete)
        XCTAssertEqual([delete], result.changes)

        let update = Difference.update(1)
        let move = Difference.move(3, 2)
        result.insert(update)
        result.insert(move)
        XCTAssertEqual(Set([delete, update, move]), Set(result.changes))
    }

    func testHasUpdates() {
        var result = Result()
        XCTAssertFalse(result.hasChanges)

        let delete = Difference.delete(0)
        result.insert(delete)
        XCTAssertTrue(result.hasChanges)

        let update = Difference.update(1)
        let move = Difference.move(3, 2)
        result.insert(update)
        result.insert(move)
        XCTAssertTrue(result.hasChanges)
    }

    func testCount() {
        var result = Result()
        XCTAssertEqual(0, result.count)

        let delete = Difference.delete(0)
        result.insert(delete)
        XCTAssertEqual(1, result.count)

        let update = Difference.update(1)
        let move = Difference.move(3, 2)
        result.insert(update)
        result.insert(move)
        XCTAssertEqual(3, result.count)
    }

    func testCollectionViewDifferences1() {
        let differences = [Difference.move(0, 2), Difference.update(0)]
        let result = Result(differences: differences)
        XCTAssertEqual(Set(differences), Set(result.changes))

        let expected = [Difference.delete(0), Difference.insert(2)]
        XCTAssertEqual(Set(expected), Set(result.collectionViewDifferences))
    }

    func testCollectionViewDifferences2() {
        let differences = [Difference.update(0)]
        let result = Result(differences: differences, old: ["0": 0], new: ["0": 2])
        XCTAssertEqual(Set(differences), Set(result.changes))

        let expected = [Difference.delete(0), Difference.insert(2)]
        XCTAssertEqual(Set(expected), Set(result.collectionViewDifferences))
    }
}
