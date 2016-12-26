import XCTest
@testable import Differences

class RangeReplaceableCollection_IndexTests: XCTestCase {
    static var allTests : [(String, (RangeReplaceableCollection_IndexTests) -> () throws -> Void)] {
        return [
            ("testElementAtInAsciiCharacterView", testElementAtInAsciiCharacterView),
            ("testElementAtInChineseCharacterView", testElementAtInChineseCharacterView),
            ("testElementAtInEmojiCharacterView", testElementAtInEmojiCharacterView),
            ("testSetElementAtInAsciiCharacterView", testSetElementAtInAsciiCharacterView),
            ("testSetElementAtInChineseCharacterView", testSetElementAtInChineseCharacterView),
            ("testSetElementAtInEmojiCharacterView", testSetElementAtInEmojiCharacterView),
        ]
    }

    func testElementAtInAsciiCharacterView() {
        let characters = "I love you".characters
        XCTAssertEqual("I".characters.first!, characters.element(at: 0))
        XCTAssertEqual(" ".characters.first!, characters.element(at: 1))
        XCTAssertEqual("l".characters.first!, characters.element(at: 2))
        XCTAssertEqual("o".characters.first!, characters.element(at: 3))
        XCTAssertEqual("v".characters.first!, characters.element(at: 4))
        XCTAssertEqual("e".characters.first!, characters.element(at: 5))
        XCTAssertEqual(" ".characters.first!, characters.element(at: 6))
        XCTAssertEqual("y".characters.first!, characters.element(at: 7))
        XCTAssertEqual("o".characters.first!, characters.element(at: 8))
        XCTAssertEqual("u".characters.first!, characters.element(at: 9))
    }

    func testElementAtInChineseCharacterView() {
        let characters = "我爱你！".characters
        XCTAssertEqual("我".characters.first!, characters.element(at: 0))
        XCTAssertEqual("爱".characters.first!, characters.element(at: 1))
        XCTAssertEqual("你".characters.first!, characters.element(at: 2))
        XCTAssertEqual("！".characters.first!, characters.element(at: 3))
    }

    // Rules for grapheme cluster boundaries in emoji sequences (e.g., 👩‍👩‍👧‍👧) are broken
    // in Swift 3. https://oleb.net/blog/2016/12/emoji-4-0/
    func testElementAtInEmojiCharacterView() {
        let characters = "❤️👧🇺🇸‼️".characters
        XCTAssertEqual("❤️".characters.first!, characters.element(at: 0))
        XCTAssertEqual("👧".characters.first!, characters.element(at: 1))
        XCTAssertEqual("🇺🇸".characters.first!, characters.element(at: 2))
        XCTAssertEqual("‼️".characters.first!, characters.element(at: 3))
    }

    func testSetElementAtInAsciiCharacterView() {
        var characters = "I love you".characters
        characters.set(element: Character("Z"), at: 0)
        characters.set(element: Character("w"), at: 8)
        XCTAssertEqual("Z".characters.first!, characters.element(at: 0))
        XCTAssertEqual("w".characters.first!, characters.element(at: 8))
        XCTAssertEqual("Z love ywu", String(characters))
    }

    func testSetElementAtInChineseCharacterView() {
        var characters = "我爱你！".characters
        characters.set(element: Character("肏"), at: 1)
        characters.set(element: Character("？"), at: 3)
        XCTAssertEqual("肏".characters.first!, characters.element(at: 1))
        XCTAssertEqual("？".characters.first!, characters.element(at: 3))
        XCTAssertEqual("我肏你？", String(characters))
    }

    // Rules for grapheme cluster boundaries in emoji sequences (e.g., 👩‍👩‍👧‍👧) are broken
    // in Swift 3. https://oleb.net/blog/2016/12/emoji-4-0/
    func testSetElementAtInEmojiCharacterView() {
        var characters = "❤️👧🇺🇸‼️".characters
        characters.set(element: Character("👹"), at: 0)
        characters.set(element: Character("👦"), at: 1)
        XCTAssertEqual("👹".characters.first!, characters.element(at: 0))
        XCTAssertEqual("👦".characters.first!, characters.element(at: 1))
        XCTAssertEqual("👹👦🇺🇸‼️", String(characters))
    }

    func testSetElementAtInEmptyCharacterView() {
        var characters: String.CharacterView = "".characters
        characters.set(element: "!", at: 0)
        XCTAssertEqual("!".characters.first!, characters.element(at: 0))
        XCTAssertEqual("!", String(characters))
    }
}
