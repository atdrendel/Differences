import Foundation

extension String {
    public enum CharacterType {
        case utf8
        case utf16
        case composedCharacters
    }
}

extension String {
    fileprivate var utf8Array: Array<UTF8.CodeUnit> {
        return self.utf8.map { $0 }
    }

    fileprivate var utf16Array: Array<UTF16.CodeUnit> {
        return self.utf16.map { $0 }
    }

    fileprivate var characterArray: Array<Character> {
        return self.map { $0 }
    }
}

extension String: Differentiable {
    public var identifier: String { return self }
}

extension String.UTF8View.Iterator.Element: Differentiable {
    public var identifier: String { return String(self) }
}

extension String.UTF16View.Iterator.Element: Differentiable {
    public var identifier: String { return String(self) }
}

extension Character: Differentiable {
    public var identifier: String { return String(self) }
}

extension String {
    public func differences(from old: String,
                            characterType: String.CharacterType = String.CharacterType.utf8) -> Differences.Result {
        switch characterType {
        case .utf8:
            return self.utf8Array.differences(from: old.utf8Array)
        case .utf16:
            return self.utf16Array.differences(from: old.utf16Array)
        case .composedCharacters:
            return self.characterArray.differences(from: old.characterArray)
        }
    }

    public func differences(to new: String,
                            characterType: String.CharacterType = String.CharacterType.utf8) -> Differences.Result {
        switch characterType {
        case .utf8:
            return self.utf8Array.differences(to: new.utf8Array)
        case .utf16:
            return self.utf16Array.differences(to: new.utf16Array)
        case .composedCharacters:
            return self.characterArray.differences(to: new.characterArray)
        }
    }
}
