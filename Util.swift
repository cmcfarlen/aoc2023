import Foundation

public func slurp(path: String) -> String {
    let url = URL(fileURLWithPath: path)
    do {
        return try String(contentsOf: url)
    } catch {
        fatalError("Failed to open: \(path)")
    }
}


public extension RandomAccessCollection {
    subscript(safe index: Index) -> Element? {
        guard index >= startIndex && index < endIndex else {
            return nil
        }
        return self[index]
    }
}

public extension Sequence {
    func partition(size n: Int, padding pad: Element? = nil) -> [[Element]] {
        var result = [[Element]]()

        var part = [Element]()
        part.reserveCapacity(n)
        for e in self {
            part.append(e)
            if part.count == n {
                result.append(part)
                part = [Element]()
                part.reserveCapacity(n)
            }
        }
        if part.count > 0 {
            if let p = pad {
                while part.count < n {
                    part.append(p)
                }
            }
            result.append(part)
        }
        return result
    }

    // from https://developer.apple.com/documentation/swift/lazysequenceprotocol
    func scan<Result>(_ initial: Result, nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var result = [initial]
        for x in self {
            result.append(nextPartialResult(result.last!, x))
        }
        return result
    }
}

public struct LazyIterateSequence<Result>
 : LazySequenceProtocol
{
    let initial: Result
    let nextFunction: (Result) -> Result

    public struct Iterator: IteratorProtocol {
        var nextElement: Result
        let nextFunction: (Result) -> Result

        public mutating func next() -> Result? {
            let result = nextElement
            nextElement = nextFunction(nextElement)
            return result
        }
    }

    public func makeIterator() -> Iterator {
        return Iterator(
            nextElement: initial,
            nextFunction: nextFunction
        )
    }
}

// returns a lazy sequence of [f(value), f(f(value)), f(f(f(value))), ...]
public func iterate<Result>(_ value: Result, _ f: @escaping (Result) -> Result) -> LazyIterateSequence<Result> {
    return LazyIterateSequence(
            initial: value, nextFunction: f
            )
}

public extension Collection {
    func partition(size n: Int, stepping step: Int) -> [[Element]] {
        if count < n {
            return []
        }
        return [Array(self.prefix(n))] + self.dropFirst(step).partition(size: n, stepping: step)
    }
}

public extension Sequence where Element: Hashable {
    var frequencies: [Element:Int] {
        self.reduce(into: [:]) { m, v in
            m[v, default: 0] += 1
        }
    }
}


