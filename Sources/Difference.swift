public enum Difference {
    case delete(Int)
    case update(Int)
    case insert(Int)
    case move(Int, Int)
}

extension Difference: CustomStringConvertible {
    public var description: String {
        switch self {
        case .delete(let index):
            return "Delete \(index)"
        case .update(let index):
            return "Update \(index)"
        case .insert(let index):
            return "Insert \(index)"
        case .move(let from, let to):
            return "Move from \(from) to \(to)"
        }
    }
}

extension Difference: Equatable {
    public static func == (lhs: Difference, rhs: Difference) -> Bool {
        switch lhs {
        case .delete(let left):
            if case .delete(let right) = rhs {
                return left == right
            } else {
                return false
            }
        case .update(let left):
            if case .update(let right) = rhs {
                return left == right
            } else {
                return false
            }
        case .insert(let left):
            if case .insert(let right) = rhs {
                return left == right
            } else {
                return false
            }
        case .move(let leftFrom, let leftTo):
            if case .move(let rightFrom, let rightTo) = rhs {
                return leftFrom == rightFrom && leftTo == rightTo
            } else {
                return false
            }
        }
    }
}

extension Difference: Hashable {
    public var hashValue: Int {
        switch self {
        case .delete(let index):
            return 1111 &+ index
        case .update(let index):
            return 2222 &+ index
        case .insert(let index):
            return 3333 &+ index
        case .move(let from, let to):
            return 4444 &+ from &+ to
        }
    }
}

extension Collection where Iterator.Element == Difference {
    public var deletes: Array<Difference> {
        return self.filter { difference in
            if case .delete(_) = difference { return true }
            else { return false }
        }
    }

    public var updates: Array<Difference> {
        return self.filter { difference in
            if case .update(_) = difference { return true }
            else { return false }
        }
    }

    public var inserts: Array<Difference> {
        return self.filter { difference in
            if case .insert(_) = difference { return true }
            else { return false }
        }
    }

    public var moves: Array<Difference> {
        return self.filter { difference in
            if case .move(_, _) = difference { return true }
            else { return false }
        }
    }

    public func contains(index: Int) -> Bool {
        let matching = self.filter { difference in
            switch difference {
            case .delete(let i):
                return i == index
            case .update(let i):
                return i == index
            case .insert(let i):
                return i == index
            case .move(let from, let to):
                return from == index || to == index
            }
        }
        return !matching.isEmpty
    }
}
