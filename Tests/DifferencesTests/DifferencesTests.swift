import XCTest
@testable import Differences

class DifferencesTests: XCTestCase {
    static var allTests : [(String, (DifferencesTests) -> () throws -> Void)] {
        return [
            ("testDeleteEquatable", testDeleteEquatable),
            ("testUpdateEquatable", testUpdateEquatable),
            ("testInsertEquatable", testInsertEquatable),
            ("testMoveEquatable", testMoveEquatable),
            ("testHashValue", testHashValue),
            ("testCollectionDifferenceAccessors", testCollectionDifferenceAccessors),
            ("testCollectionContainsIndex", testCollectionContainsIndex),
        ]
    }

    func testDeleteEquatable() {
        let target = Difference.delete(1)
        let equal = Difference.delete(1)
        let unequal1 = Difference.delete(2)
        let unequal2 = Difference.insert(1)
        XCTAssertEqual(target, equal)
        XCTAssertNotEqual(target, unequal1)
        XCTAssertNotEqual(target, unequal2)
    }

    func testUpdateEquatable() {
        let target = Difference.update(1)
        let equal = Difference.update(1)
        let unequal1 = Difference.update(2)
        let unequal2 = Difference.insert(1)
        XCTAssertEqual(target, equal)
        XCTAssertNotEqual(target, unequal1)
        XCTAssertNotEqual(target, unequal2)
    }

    func testInsertEquatable() {
        let target = Difference.insert(1)
        let equal = Difference.insert(1)
        let unequal1 = Difference.insert(2)
        let unequal2 = Difference.delete(1)
        XCTAssertEqual(target, equal)
        XCTAssertNotEqual(target, unequal1)
        XCTAssertNotEqual(target, unequal2)
    }

    func testMoveEquatable() {
        let target = Difference.move(1, 2)
        let equal = Difference.move(1, 2)
        let unequal1 = Difference.move(2, 2)
        let unequal2 = Difference.move(2, 1)
        let unequal3 = Difference.delete(1)
        XCTAssertEqual(target, equal)
        XCTAssertNotEqual(target, unequal1)
        XCTAssertNotEqual(target, unequal2)
        XCTAssertNotEqual(target, unequal3)
    }

    func testHashValue() {
        XCTAssertEqual(Difference.delete(123), Difference.delete(123))
        XCTAssertEqual(Difference.update(123), Difference.update(123))
        XCTAssertEqual(Difference.insert(123), Difference.insert(123))
        XCTAssertEqual(Difference.move(123, 321), Difference.move(123, 321))
    }

    func testCollectionDifferenceAccessors() {
        let deletes: Array<Difference> = [.delete(1), .delete(2)]
        let updates: Array<Difference> = [.update(3), .update(4)]
        let inserts: Array<Difference> = [.insert(1), .insert(4)]
        let moves: Array<Difference> = [.move(4, 1), .move(3, 2), .move(3, 2)]

        let differences = Array<Difference>(deletes + updates + inserts + moves)

        XCTAssertEqual(deletes, differences.deletes)
        XCTAssertEqual(updates, differences.updates)
        XCTAssertEqual(inserts, differences.inserts)
        XCTAssertEqual(moves, differences.moves)
    }

    func testCollectionContainsIndex() {
        let deletes: Array<Difference> = [.delete(1), .delete(2)]
        let updates: Array<Difference> = [.update(3), .update(4)]
        let inserts: Array<Difference> = [.insert(1), .insert(4)]
        let moves: Array<Difference> = [.move(4, 1), .move(3, 2), .move(3, 2)]

        XCTAssertTrue(deletes.contains(index: 1))
        XCTAssertTrue(updates.contains(index: 3))
        XCTAssertTrue(inserts.contains(index: 4))
        XCTAssertTrue(moves.contains(index: 1))
        XCTAssertTrue(moves.contains(index: 3))

        XCTAssertFalse(deletes.contains(index: 3))
        XCTAssertFalse(updates.contains(index: 1))
        XCTAssertFalse(inserts.contains(index: 3))
        XCTAssertFalse(moves.contains(index: 5))
    }

    func testCollectionPositionOfIndex() {
        let deletes: Array<Difference> = [.delete(1), .delete(2)]
        let updates: Array<Difference> = [.update(3), .update(4)]
        let inserts: Array<Difference> = [.insert(1), .insert(4)]
        let moves: Array<Difference> = [.move(4, 1), .move(3, 2), .move(3, 2)]

        XCTAssertEqual(0, deletes.position(of: 1))
        XCTAssertEqual(0, updates.position(of: 3))
        XCTAssertEqual(1, inserts.position(of: 4))
        XCTAssertEqual(0, moves.position(of: 1))
        XCTAssertEqual(1, moves.position(of: 3))

        XCTAssertNil(deletes.position(of: 3))
        XCTAssertNil(updates.position(of: 1))
        XCTAssertNil(inserts.position(of: 3))
        XCTAssertNil(moves.position(of: 5))
    }
}
