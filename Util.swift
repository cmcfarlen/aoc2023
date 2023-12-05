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
