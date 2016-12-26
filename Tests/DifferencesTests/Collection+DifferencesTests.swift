import XCTest
@testable import Differences

extension Int: Differentiable {
    public var identifier: String { return "\(self)" }
}

struct Test {
    let id: String
    var value: Int
}

extension Test: Differentiable {
    static func == (lhs: Test, rhs: Test) -> Bool {
        return lhs.id == rhs.id && lhs.value == rhs.value
    }
    public var identifier: String { return id }
}

class Array_DifferencesTests: XCTestCase {
    static var allTests : [(String, (Array_DifferencesTests) -> () throws -> Void)] {
        return [
            ("testFromEmptyToEmpty", testFromEmptyToEmpty),
            ("testFromEmptyToOne", testFromEmptyToOne),
            ("testFromOneToEmpty", testFromOneToEmpty),
            ("testDeleteIndexZero", testDeleteIndexZero),
            ("testDeleteIndexesZeroAndThree", testDeleteIndexesZeroAndThree),
            ("testInsertIndexTwo", testInsertIndexTwo),
            ("testInsertIndexesZeroAndThree", testInsertIndexesZeroAndThree),
            ("testDeleteAndInsertIndexZero", testDeleteAndInsertIndexZero),
            ("testMoveIndexZeroToTwo", testMoveIndexZeroToTwo),
            ("testMoveIndexZeroToOne", testMoveIndexZeroToOne),
            ("testMoveThreeIndexesWithDuplicates", testMoveThreeIndexesWithDuplicates),
            ("testMoveFourIndexes", testMoveFourIndexes),
            ("testInsertDeleteAndMove", testInsertDeleteAndMove),
            ("testUpdateIndexZero", testUpdateIndexZero),
            ("testUpdateIndexOne", testUpdateIndexOne),
            ("testUpdateIndexesOneAndTwo", testUpdateIndexesOneAndTwo),
            ("testMoveAndUpdate", testMoveAndUpdate),
            ("testNoChangesWithDuplicatesAtStartAndEnd", testNoChangesWithDuplicatesAtStartAndEnd),
            ("testDeleteIndexOneWithDuplicatesAtStartAndEnd", testDeleteIndexOneWithDuplicatesAtStartAndEnd),
            ("testDeleteIndexesZeroAndThreeWithDuplicatesAtStartAndEnd", testDeleteIndexesZeroAndThreeWithDuplicatesAtStartAndEnd),
            ("testUpdateIndexOneWithDuplicatesAtStartAndEnd", testUpdateIndexOneWithDuplicatesAtStartAndEnd),
            ("testInsertIndexZeroAndFiveWithDuplicatesAtStartAndEnd", testInsertIndexZeroAndFiveWithDuplicatesAtStartAndEnd),
            ("testSwapIndexesOneAndTwoWithDuplicatesAtStartAndEnd", testSwapIndexesOneAndTwoWithDuplicatesAtStartAndEnd),
            ("testPerformanceWithOneThousandIntegers", testPerformanceWithOneThousandIntegers),
        ]
    }

    func testFromEmptyToEmpty() {
        let old = Array<Int>()
        let new = Array<Int>()
        let expected: Array<Difference> = []
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testFromEmptyToOne() {
        let old = Array<Int>()
        let new = [1]
        let expected: Array<Difference> = [.insert(0)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testFromOneToEmpty() {
        let old = [1]
        let new = Array<Int>()
        let expected: Array<Difference> = [.delete(0)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testDeleteIndexZero() {
        let old = [0, 1, 2]
        let new = [1, 2]
        let expected: Array<Difference> = [.delete(0)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testDeleteIndexesZeroAndThree() {
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

    func testMoveIndexZeroToOne() {
        let old = [0, 1]
        let new = [1, 0]
        let expected: Array<Difference> = [.move(1, 0), .move(0, 1)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testMoveThreeIndexesWithDuplicates() {
        let old = [0, 1, 2, 2, 3]
        let new = [1, 2, 0, 2, 3]
        let expected: Array<Difference> = [.move(1, 0), .move(2, 1), .move(0, 2)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testMoveFourIndexes() {
        let old = [0, 1, 2, 3, 4, 5, 6]
        let new = [0, 1, 4, 5, 2, 3, 6]
        let expected: Array<Difference> = [.move(2, 4), .move(3, 5), .move(4, 2), .move(5, 3)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testInsertDeleteAndMove() {
        let old = [0, 1, 2, 3]
        let new = [1, 3, 4, 2]
        let expected: Array<Difference> = [.delete(0), .insert(2), .move(3, 1), .move(2, 3)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testUpdateIndexZero() {
        let old = [Test(id: "1", value: 1)]
        let new = [Test(id: "1", value: 2)]
        let expected: Array<Difference> = [.update(0)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testUpdateIndexOne() {
        let old = [Test(id: "0", value: 0), Test(id: "1", value: 1), Test(id: "2", value: 2)]
        let new = [Test(id: "0", value: 0), Test(id: "1", value: 2), Test(id: "2", value: 2)]
        let expected: Array<Difference> = [.update(1)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testUpdateIndexesOneAndTwo() {
        let old = [Test(id: "0", value: 0), Test(id: "1", value: 1), Test(id: "2", value: 2)]
        let new = [Test(id: "0", value: 0), Test(id: "1", value: 2), Test(id: "2", value: 3)]
        let expected: Array<Difference> = [.update(1), .update(2)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testMoveAndUpdate() {
        let old = [Test(id: "0", value: 0), Test(id: "1", value: 1), Test(id: "2", value: 2)]
        let new = [Test(id: "2", value: 3), Test(id: "1", value: 1), Test(id: "0", value: 0)]
        let expected: Array<Difference> = [.move(2, 0), .move(0, 2), .update(2)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testNoChangesWithDuplicatesAtStartAndEnd() {
        let old = [
            Test(id: "0", value: 0),
            Test(id: "1", value: 1),
            Test(id: "2", value: 2),
            Test(id: "0", value: 0)
        ]
        let new = [
            Test(id: "0", value: 0),
            Test(id: "1", value: 1),
            Test(id: "2", value: 2),
            Test(id: "0", value: 0)
        ]
        let expected: Array<Difference> = []
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testDeleteIndexOneWithDuplicatesAtStartAndEnd() {
        let old = [
            Test(id: "0", value: 0),
            Test(id: "1", value: 1),
            Test(id: "2", value: 2),
            Test(id: "0", value: 0)
        ]
        let new = [
            Test(id: "0", value: 0),
            Test(id: "2", value: 2),
            Test(id: "0", value: 0)
        ]
        let expected: Array<Difference> = [.delete(1)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testDeleteIndexesZeroAndThreeWithDuplicatesAtStartAndEnd() {
        let old = [
            Test(id: "0", value: 0),
            Test(id: "1", value: 1),
            Test(id: "2", value: 2),
            Test(id: "0", value: 0)
        ]
        let new = [
            Test(id: "1", value: 1),
            Test(id: "2", value: 2),
        ]
        let expected: Array<Difference> = [.delete(0), .delete(3)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testUpdateIndexOneWithDuplicatesAtStartAndEnd() {
        let old = [
            Test(id: "0", value: 0),
            Test(id: "1", value: 1),
            Test(id: "2", value: 2),
            Test(id: "0", value: 0)
        ]
        let new = [
            Test(id: "0", value: 0),
            Test(id: "1", value: 3),
            Test(id: "2", value: 2),
            Test(id: "0", value: 0)
        ]
        let expected: Array<Difference> = [.update(1)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testInsertIndexZeroAndFiveWithDuplicatesAtStartAndEnd() {
        let old = [
            Test(id: "0", value: 0),
            Test(id: "1", value: 1),
            Test(id: "2", value: 2),
            Test(id: "0", value: 0)
        ]
        let new = [
            Test(id: "3", value: 3),
            Test(id: "0", value: 0),
            Test(id: "1", value: 1),
            Test(id: "2", value: 2),
            Test(id: "0", value: 0),
            Test(id: "4", value: 4)
        ]
        let expected: Array<Difference> = [.insert(0), .insert(5)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testSwapIndexesOneAndTwoWithDuplicatesAtStartAndEnd() {
        let old = [
            Test(id: "0", value: 0),
            Test(id: "1", value: 1),
            Test(id: "2", value: 2),
            Test(id: "0", value: 0)
        ]
        let new = [
            Test(id: "0", value: 0),
            Test(id: "2", value: 2),
            Test(id: "1", value: 1),
            Test(id: "0", value: 0)
        ]
        let expected: Array<Difference> = [.move(1, 2), .move(2, 1)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    // Tests are run unoptimized, which means that increasing the count above 1000
    // dramatically increases the test run time. However, when run with optimizations
    // enabled, run time seems to increase linearly, which is expected.
    func testPerformanceWithOneThousandIntegers() {
        let old = _randomArray(count: 1000)
        let new = _randomArray(count: 1000)
        var result: Result? = nil
        self.measure { result = old.differences(to: new) }
        XCTAssertNotNil(result)
    }

    // MARK: Helpers
    private func _assert<A: Differentiable>(
                         expected: Array<Difference>,
                         equalsOld old: Array<A>,
                         diffedWithNew new: Array<A>) {
        let toNewDiffs = old.differences(to: new)
        let fromOldDiffs = new.differences(from: old)
        XCTAssertEqual(expected.count > 0, toNewDiffs.hasChanges)
        XCTAssertEqual(expected.count > 0, fromOldDiffs.hasChanges)
        XCTAssertEqual(expected.count, toNewDiffs.count)
        XCTAssertEqual(expected.count, fromOldDiffs.count)
        XCTAssertEqual(Set(expected), Set(toNewDiffs.changes))
        XCTAssertEqual(Set(expected), Set(fromOldDiffs.changes))
    }

    private func _randomArray(count: Int) -> Array<Int> {
        return (0..<count).map { _ in Int(arc4random_uniform(10)) }
    }
}
