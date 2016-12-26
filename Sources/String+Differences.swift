extension String {
    public var characterArray: Array<Character> {
        return self.characters.map { $0 }
    }
}

extension String: Differentiable {
    public var identifier: String { return self }
}

extension Character: Differentiable {
    public var identifier: String { return String(self) }
}

extension String {
    public func differences(from old: String) -> Differences.Result {
        return characterArray.differences(from: old.characterArray)
    }

    public func differences(to new: String) -> Differences.Result {
        return characterArray.differences(to: new.characterArray)
    }
}
