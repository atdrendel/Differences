extension RangeReplaceableCollection where IndexDistance == Int {
    internal func element(at position: Int) -> Self.Iterator.Element {
        var index = self.startIndex
        self.formIndex(&index, offsetBy: position)
        return self[index]
    }

    internal mutating func set(element: Self.Iterator.Element, at position: Int) {
        var index = self.startIndex
        self.formIndex(&index, offsetBy: position)
        if index < self.endIndex { self.remove(at: index) }
        self.insert(element, at: index)
    }
}
