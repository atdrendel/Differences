import XCTest
@testable import Differences

extension Int: Differentiable {
    public var identifier: String { return "\(self)" }
}

class Array_DifferencesTests: XCTestCase {
    static var allTests : [(String, (Array_DifferencesTests) -> () throws -> Void)] {
        return [
            ("testDeleteIndexZero", testDeleteIndexZero),
            ("testDeleteZeroAndThree", testDeleteZeroAndThree),
            ("testInsertIndexTwo", testInsertIndexTwo),
            ("testInsertIndexesZeroAndThree", testInsertIndexesZeroAndThree),
            ("testDeleteAndInsertIndexZero", testDeleteAndInsertIndexZero),
            ("testMoveIndexZeroToTwo", testMoveIndexZeroToTwo),
        ]
    }

    func testDeleteIndexZero() {
        let old = [0, 1, 2]
        let new = [1, 2]
        let expected: Array<Difference> = [.delete(0)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testDeleteZeroAndThree() {
        let old = [2, 0, 1, 3]
        let new = [0, 1]
        let expected: Array<Difference> = [.delete(0), .delete(3)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testInsertIndexTwo() {
        let old = [0, 1]
        let new = [0, 1, 2]
        let expected: Array<Difference> = [.insert(2)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testInsertIndexesZeroAndThree() {
        let old = [0, 1]
        let new = [2, 0, 1, 3]
        let expected: Array<Difference> = [.insert(0), .insert(3)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testDeleteAndInsertIndexZero() {
        let old = [0, 1, 2]
        let new = [3, 1, 2]
        let expected: Array<Difference> = [.delete(0), .insert(0)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testMoveIndexZeroToTwo() {
        let old = [0, 1, 2]
        let new = [1, 2, 0]
        let expected: Array<Difference> = [.move(1, 0), .move(2, 1), .move(0, 2)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testMove() {
        let old = [0, 1, 2, 2, 3]
        let new = [1, 2, 0, 2, 3]
        // [Move from 3 to 1, Move from 1 to 0, Move from 0 to 2, Move from 2 to 3]
        let expected: Array<Difference> = [.move(1, 0), .move(2, 1), .move(0, 2)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    // MARK: Helpers
    private func _assert(expected: Array<Difference>, equalsOld old: Array<Int>, diffedWithNew new: Array<Int>) {
        _assert(expected: Set(expected), equalsOld: old, diffedWithNew: new)
    }

    private func _assert(expected: Set<Difference>, equalsOld old: Array<Int>, diffedWithNew new: Array<Int>) {
        XCTAssertEqual(expected, Set(old.differences(to: new).changes))
        XCTAssertEqual(expected, Set(new.differences(from: old).changes))
    }
}
