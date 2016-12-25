import Foundation

public protocol Differentiable: Equatable {
    var identifier: String { get }
}

private func == <A: Equatable>(lhs: A?, rhs: A?) -> Bool {
    switch (lhs, rhs) {
    case (.some(let left), .some(let right)):
        return left == right
    case (.none, .none):
        return true
    default:
        return false
    }
}

private struct Indexes: Equatable {
    private var _array = Array<Int>()

    fileprivate mutating func push(_ int: Int) {
        _array.append(int)
    }

    fileprivate mutating func pop(matching int: Int) -> Int? {
        guard !_array.isEmpty else { return nil }
        if let matchingIndex = _array.index(of: int) {
            let matching = _array[matchingIndex]
            _array.remove(at: matchingIndex)
            return matching
        } else {
            let nonmatching = _array[0]
            _array.remove(at: 0)
            return nonmatching
        }
    }

    static func == (lhs: Indexes, rhs: Indexes) -> Bool {
        return lhs._array == rhs._array
    }
}

private class Entry {
    var oldCount = 0
    var newCount = 0
    var oldIndexes = Indexes()
    var isUpdated: Bool = false
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.oldCount == rhs.oldCount && lhs.newCount == rhs.newCount &&
               lhs.oldIndexes == rhs.oldIndexes && lhs.isUpdated == rhs.isUpdated
    }
}

extension Entry: CustomStringConvertible {
    var description: String {
        return "Entry { old count: \(oldCount), new count: \(newCount), old indexes: \(oldIndexes), is updated: \(isUpdated) }"
    }
}

private enum Record {
    case entry(Entry)
    case index(Int)
}

extension Record: Equatable {
    static func == (lhs: Record, rhs: Record) -> Bool {
        switch lhs {
        case .entry(let left):
            if case .entry(let right) = rhs {
                return left == right
            } else {
                return false
            }
        case .index(let left):
            if case .index(let right) = rhs {
                return left == right
            } else {
                return false
            }
        }
    }
}

extension Record: CustomStringConvertible {
    var description: String {
        switch self {
        case .entry(let entry):
            return "Record { Entry: \(entry) }"
        case .index(let index):
            return "Record { Index: \(index) }"
        }
    }
}

public extension Collection where Iterator.Element: Differentiable, Index == Int, IndexDistance == Int {
    private static func differences(from old: Self, to new: Self) -> Differences.Result {
        let oldCount = old.count
        let newCount = new.count

        var symbolTable = Dictionary<String, Entry>()

        func records(
            from collection: Self,
            symbolTable: inout Dictionary<String, Entry>,
            configure block: (Int, Entry) -> Entry) -> Array<Record> {
            return collection.enumerated().map { (index, element) -> Record in
                let entry = symbolTable[element.identifier] ?? Entry()
                let configured = block(index, entry)
                symbolTable[element.identifier] = configured
                return Record.entry(configured)
            }
        }

        // Step 1
        var newRecords = records(from: new, symbolTable: &symbolTable) { (_, entry) -> Entry in
            entry.newCount += 1
            return entry
        }

        // Step 2
        var oldRecords = records(from: old, symbolTable: &symbolTable) { (index, entry) -> Entry in
            entry.oldCount += 1
            entry.oldIndexes.push(index)
            return entry
        }

        // Step 3
        for (newIndex, newRecord) in newRecords.enumerated() {
            guard case .entry(let newEntry) = newRecord else {
                assertionFailure("\(newRecord) should be .entity")
                continue
            }

            let oldIndex = newEntry.oldIndexes.pop(matching: newIndex)

            if let oldIndex = oldIndex {
                if newEntry.oldCount > 0 && newEntry.newCount > 0 {
                    newRecords[newIndex] = .index(oldIndex)
                    oldRecords[oldIndex] = .index(newIndex)
                }
            }
        }

        // Step 4
        var newRecordsCopy = newRecords
        for (newIndex, newRecord) in newRecordsCopy.enumerated() {
            let nextNewIndex = newIndex + 1
            guard nextNewIndex < newRecords.count else { continue }
            if case .index(let oldIndex) = newRecord {
                let nextOldIndex = oldIndex + 1
                guard nextOldIndex < oldRecords.count else { continue }
                guard case .entry(let nextOldEntry) = oldRecords[nextOldIndex],
                    case .entry(let nextNewEntry) = newRecords[nextNewIndex]
                    else { continue }
                if nextOldEntry == nextNewEntry {
                    oldRecords[nextOldIndex] = .index(nextNewIndex)
                    newRecords[nextNewIndex] = .index(nextOldIndex)
                }
            }
        }

        // Step 5
        newRecordsCopy = newRecords
        for (newIndex, newRecord) in newRecordsCopy.reversed().enumerated() {
            let prevNewIndex = newIndex - 1
            guard prevNewIndex >= 0 else { continue }
            if case .index(let oldIndex) = newRecord {
                let prevOldIndex = oldIndex - 1
                guard prevOldIndex >= 0,
                    case .entry(let prevOldEntry) = oldRecords[prevOldIndex],
                    case .entry(let prevNewEntry) = newRecords[prevNewIndex]
                    else { continue }
                if prevOldEntry == prevNewEntry {
                    oldRecords[prevOldIndex] = .index(prevNewIndex)
                    newRecords[prevNewIndex] = .index(prevOldIndex)
                }
            }
        }

        var results = Array<Difference>()

        var oldMap = Dictionary<String, Int>()
        var newMap = Dictionary<String, Int>()

        var deleteOffsets = Array<Int>()
        var insertOffsets = Array<Int>()
        var currentOffset = 0

        for (oldIndex, oldRecord) in oldRecords.enumerated() {
            deleteOffsets.append(currentOffset)
            if case .entry(_) = oldRecord {
                results.append(.delete(oldIndex))
                currentOffset += 1
            }
            oldMap[old[oldIndex].identifier] = oldIndex
        }

        currentOffset = 0
        for (newIndex, newRecord) in newRecords.enumerated() {
            insertOffsets.append(currentOffset)
            switch newRecord {
            case .entry(_):
                results.append(.insert(newIndex))
                currentOffset += 1
            case .index(let oldIndex):

                if old[oldIndex] != new[newIndex] {
                    results.append(.update(oldIndex))
                }

                let deleteOffset = deleteOffsets[oldIndex]
                let insertOffset = insertOffsets[newIndex]
                if (oldIndex - deleteOffset + insertOffset) != newIndex {
                    results.append(.move(oldIndex, newIndex))
                }
            }
            newMap[new[newIndex].identifier] = newIndex
        }
        
        return Differences.Result(differences: results, old: oldMap, new: newMap)

    }

    public func differences(from old: Self) -> Differences.Result {
        return Self.differences(from: old, to: self)
    }

    public func differences(to new: Self) -> Differences.Result {
        return Self.differences(from: self, to: new)
    }
}
