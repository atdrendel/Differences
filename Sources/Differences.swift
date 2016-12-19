public enum Difference: Equatable {
    case delete(Int)
    case update(Int)
    case insert(Int)
    case move(Int)
}

public extension Difference {
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
        case .move(let left):
            if case .move(let right) = rhs {
                return left == right
            } else {
                return false
            }
        }
    }
}
