import Foundation
import Util

let data = slurp(path: "day9.data").split(separator: "\n")
                .map { line in
                    line.split(separator: " ").map { Int(String($0))! }
                }

func extrapolateNext(from value: [Int]) -> Int {
    let reductions = iterate(value) { $0.partition(size: 2, stepping: 1)
                       .map { $0.last! - $0.first! } }
                       .prefix { !$0.allSatisfy { $0 == 0 } }
    return reductions.reversed().reduce(0) { x, n in
        x + n.last!
    }
}

let answer = data.map(extrapolateNext(from:)).reduce(0, +)

print(answer)

