import XCTest
@testable import Differences

class String_Differences: XCTestCase {
    static var allTests : [(String, (String_Differences) -> () throws -> Void)] {
        return [
            ("testUTF8InsertAtStart", testUTF8InsertAtStart),
            ("testUTF8InsertAtEnd", testUTF8InsertAtEnd),
            ("testUTF8InsertChineseAndDeleteAscii", testUTF8InsertChineseAndDeleteAscii),
            ("testUTF8DeleteChineseAndMoveEmoji", testUTF8DeleteChineseAndMoveEmoji),
            ("testUTF16InsertAtStart", testUTF16InsertAtStart),
            ("testUTF16InsertAtEnd", testUTF16InsertAtEnd),
            ("testUTF16InsertChineseAndDeleteAscii", testUTF16InsertChineseAndDeleteAscii),
            ("testUTF16DeleteChineseAndMoveEmoji", testUTF16DeleteChineseAndMoveEmoji),
            ("testComposedCharactersInsertAtStart", testComposedCharactersInsertAtStart),
            ("testComposedCharactersInsertAtEnd", testComposedCharactersInsertAtEnd),
            ("testComposedCharactersInsertChineseAndDeleteAscii", testComposedCharactersInsertChineseAndDeleteAscii),
            ("testComposedCharactersDeleteChineseAndMoveEmoji", testComposedCharactersDeleteChineseAndMoveEmoji),
        ]
    }

    func testUTF8InsertAtStart() {
        let old = "Test"
        let new = "ReTest"
        let expected: Array<Difference> = [.insert(0), .insert(3), .move(0, 2)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testUTF8InsertAtEnd() {
        let old = "Test"
        let new = "Tester"
        let expected: Array<Difference> = [.insert(4), .insert(5)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testUTF8InsertChineseAndDeleteAscii() {
        let old = "Test"
        let new = "Te考试t"
        let expected: Array<Difference> = [
            .delete(2),
            .insert(2),
            .insert(3),
            .insert(4),
            .insert(5),
            .insert(6),
            .insert(7)
        ]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testUTF8DeleteChineseAndMoveEmoji() {
        let old = "👦男孩脸"
        let new = "男👦脸"
        let expected: Array<Difference> = [
            .delete(7),
            .delete(8),
            .delete(9),
            .move(4, 0),
            .move(5, 1),
            .move(6, 2),
            .move(0, 3),
            .move(1, 4),
            .move(2, 5),
            .move(3, 6),
        ]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new)
    }

    func testUTF16InsertAtStart() {
        let old = "Test"
        let new = "ReTest"
        let expected: Array<Difference> = [.insert(0), .insert(3), .move(0, 2)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new, characterType: .utf16)
    }

    func testUTF16InsertAtEnd() {
        let old = "Test"
        let new = "Tester"
        let expected: Array<Difference> = [.insert(4), .insert(5)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new, characterType: .utf16)
    }

    func testUTF16InsertChineseAndDeleteAscii() {
        let old = "Test"
        let new = "Te考试t"
        let expected: Array<Difference> = [
            .delete(2),
            .insert(2),
            .insert(3)
        ]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new, characterType: .utf16)
    }

    func testUTF16DeleteChineseAndMoveEmoji() {
        let old = "👦男孩脸"
        let new = "男👦脸"
        let expected: Array<Difference> = [
            .delete(3),
            .move(2, 0),
            .move(0, 1),
            .move(1, 2),
            ]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new, characterType: .utf16)
    }

    func testComposedCharactersInsertAtStart() {
        let old = "Test"
        let new = "ReTest"
        let expected: Array<Difference> = [.insert(0), .insert(3), .move(0, 2)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new, characterType: .composedCharacters)
    }

    func testComposedCharactersInsertAtEnd() {
        let old = "Test"
        let new = "Tester"
        let expected: Array<Difference> = [.insert(4), .insert(5)]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new, characterType: .composedCharacters)
    }

    func testComposedCharactersInsertChineseAndDeleteAscii() {
        let old = "Test"
        let new = "Te考试t"
        let expected: Array<Difference> = [
            .delete(2),
            .insert(2),
            .insert(3)
        ]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new, characterType: .composedCharacters)
    }

    func testComposedCharactersDeleteChineseAndMoveEmoji() {
        let old = "👦男孩脸"
        let new = "男👦脸"
        let expected: Array<Difference> = [
            .delete(2),
            .move(1, 0),
            .move(0, 1),
            ]
        _assert(expected: expected, equalsOld: old, diffedWithNew: new, characterType: .composedCharacters)
    }

    // MARK: Helpers
    private func _assert(
        expected: Array<Difference>,
        equalsOld old: String,
        diffedWithNew new: String,
        characterType: String.CharacterType = .utf8) {
        let toNewDiffs = old.differences(to: new, characterType: characterType)
        let fromOldDiffs = new.differences(from: old, characterType: characterType)
        XCTAssertEqual(expected.count > 0, toNewDiffs.hasChanges)
        XCTAssertEqual(expected.count > 0, fromOldDiffs.hasChanges)
        XCTAssertEqual(expected.count, toNewDiffs.count)
        XCTAssertEqual(expected.count, fromOldDiffs.count)
        XCTAssertEqual(Set(expected), Set(toNewDiffs.changes))
        XCTAssertEqual(Set(expected), Set(fromOldDiffs.changes))
    }
}
