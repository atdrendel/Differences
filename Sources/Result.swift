public struct Result {
    fileprivate var _differences: Set<Difference>
    fileprivate var _oldIdentifierToIndexMap: Dictionary<String, Int>
    fileprivate var _newIdentifierToIndexMap: Dictionary<String, Int>

    public init(differences: Array<Difference> = [],
                old: Dictionary<String, Int> = [:],
                new: Dictionary<String, Int> = [:]) {
        _differences = Set(differences)
        _oldIdentifierToIndexMap = old
        _newIdentifierToIndexMap = new
    }

    public var deletes: Array<Difference> { return _differences.deletes }
    public var updates: Array<Difference> { return _differences.updates }
    public var inserts: Array<Difference> { return _differences.inserts }
    public var moves: Array<Difference> { return _differences.moves }
    public var changes: Array<Difference> { return Array(_differences) }
    public var hasChanges: Bool { return !changes.isEmpty }
    public var count: Int { return _differences.count }

    // The logic for this comes from Instagram's IGListKit.
    // https://github.com/Instagram/IGListKit/blob/master/Source/Common/IGListIndexSetResult.m#L41
    public var collectionViewDifferences: Array<Difference> {
        var deletes = self.deletes
        var updates = self.updates
        var inserts = self.inserts
        var moves = self.moves

        func removeDifference(with index: Int, from array: inout Array<Difference>) {
            let copy = array
            for (i, difference) in copy.enumerated() {
                switch (difference) {
                case .move(let from, let to):
                    if from == index || to == index { array.remove(at: i) }
                case .delete(let deleteIndex):
                    if deleteIndex == index { array.remove(at: i) }
                case .insert(let insertIndex):
                    if insertIndex == index { array.remove(at: i) }
                case .update(let updateIndex):
                    if updateIndex == index { array.remove(at: i) }
                }
            }
        }

        let movesCopy = moves
        for (index, move) in movesCopy.reversed().enumerated() {
            guard case .move(let from, let to) = move else {
                assertionFailure("\(move) must be .move")
                continue
            }
            let convertedIndex = movesCopy.count - index - 1
            if updates.contains(index: from) {
                moves.remove(at: convertedIndex)
                removeDifference(with: from, from: &updates)
                deletes.append(.delete(from))
                inserts.append(.insert(to))
            }
        }

        for (identifier, oldIndex) in _oldIdentifierToIndexMap {
            if let updateIndex = updates.position(of: oldIndex) {
                guard let newIndex = _newIdentifierToIndexMap[identifier] else {
                    assertionFailure("Index for \(identifier) should exist in \(_newIdentifierToIndexMap)")
                    continue
                }
                updates.remove(at: updateIndex)
                deletes.append(.delete(oldIndex))
                inserts.append(.insert(newIndex))
            }
        }

        return Array(deletes + updates + inserts + moves)
    }

    public mutating func insert(_ difference: Difference) {
        _differences.insert(difference)
    }
}

extension Result: CustomStringConvertible {
    public var description: String {
        return "Differences { Changes: \(_differences) }"
    }
}
