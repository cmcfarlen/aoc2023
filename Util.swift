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
}
