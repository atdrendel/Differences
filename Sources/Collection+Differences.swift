import Foundation

public extension Collection where Iterator.Element: Equatable, Index == Int {
    private static func differences(from old: Self, to new: Self) -> Array<Difference> {
        return [.update(0)]
    }

    public func differences(to new: Self) -> Array<Difference> {
        return Self.differences(from: self, to: new)
    }

    public func differences(from old: Self) -> Array<Difference> {
        return Self.differences(from: old, to: self)
    }
}
