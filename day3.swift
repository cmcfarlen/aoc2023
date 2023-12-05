import Foundation
import Util

struct Coord {
    var x: Int
    var y: Int
}

extension Coord: CustomStringConvertible {
    var description: String {
        "(\(x),\(y))"
    }
}

extension Coord {
    var around: [Coord] {
        [
            Coord(x: x-1, y: y-1),
            Coord(x: x, y: y-1),
            Coord(x: x+1, y: y-1),
            Coord(x: x-1, y: y),
            Coord(x: x+1, y: y),
            Coord(x: x-1, y: y+1),
            Coord(x: x, y: y+1),
            Coord(x: x+1, y: y+1),
        ]
    }

    static func cartesian(width: Int, height: Int) -> [Coord] {
        (0..<width).flatMap { cx in
          (0..<height).map { cy in
             Coord(x: cx, y: cy)
          }
        }
    }
    static func cartesian(size: Coord) -> [Coord] {
        cartesian(width: size.x, height: size.y)
    }
}

enum Location {
    case empty
    case number(Int)
    case symbol(Character)

    init(_ ch: Character) {
        if ch == "." {
            self = .empty
        } else if ch.isNumber {
            self = .number(ch.wholeNumberValue!)
        } else {
            self = .symbol(ch)
        }
    }
}

extension Location: CustomStringConvertible {
    var description: String {
        switch self {
            case .empty: return "."
            case .number(let x): return "\(x)"
            case .symbol(let x): return "\(x)"
        }
    }

    var value: Int {
        if case let .number(x) = self {
            return x
        }
        return 0
    }
}

func parse(data: String) -> [[Location]] {
    return data.split(separator: "\n")
    .map { line in
        line.map { Location($0) }
    }
}

struct Schematic {
    var locations: [[Location]]
    var size: Coord {
        Coord(x: locations.first!.count, y: locations.count)
    }

    init(data: String) {
        locations = parse(data: data)
    }

    func location(at: Coord) -> Location? {
        locations[safe: at.y]?[safe: at.x]
    }

}

extension Schematic: CustomStringConvertible {
    var description: String {
        locations.map { row in
            row.map(\.description).joined()
        }
        .joined(separator: "\n")
    }
    
}

let data = slurp(path: "day3.data")

let schem = Schematic(data: data)

let test = Coord(x: 3, y: 1)
print("loc \(test) = \(String(describing: schem.location(at: test)))")

print("around \(test): \(test.around)")
print("cartesian \(Coord.cartesian(width: 5, height: 5))")

let answer = Coord.cartesian(size: schem.size)
            .map { c in
               (c, schem.location(at: c)!)
            }
            .filter { (_, loc) in
                switch loc {
                    case .symbol(_): return true
                    default: return false
                }
            }
            .flatMap { (c, loc) in
                c.around.compactMap { schem.location(at: $0) }.map(\.value)
            }
            .reduce(0, +)


print("answer: \(answer)")

