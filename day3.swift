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

    var left: Coord {
        Coord(x: x - 1, y: y)
    }
    var right: Coord {
        Coord(x: x + 1, y: y)
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

    var value: Int {
        if case let .number(x) = self {
            return x
        }
        return 0
    }

    static func isNumber(_ lin: Location?) -> Bool {
        guard let l = lin else {
            return false
        }
        switch l {
            case .number(_): return true
            default: return false
        }
    }

    static func isSymbol(_ lin: Location?) -> Bool {
        guard let l = lin else {
            return false
        }
        switch l {
            case .symbol(_): return true
            default: return false
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

    func value(at loc: Coord) -> Int {
        var result = 0
        var cur = loc
        var start = loc
        var p = location(at: loc)
        while Location.isNumber(p) {
            start = cur
            cur = cur.left
            p = location(at: cur)
        }

        print("in \(loc) start \(start)")

        p = location(at: start)
        while case .number(let n) = p {
            result *= 10
            result += n
            start = start.right
            p = location(at: start)
        }

        return result
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

/*
let test = Coord(x: 3, y: 1)
print("loc \(test) = \(String(describing: schem.location(at: test)))")

print("around \(test): \(test.around)")
print("cartesian \(Coord.cartesian(width: 5, height: 5))")

print("value at \(schem.value(at: Coord(x: 1, y: 0)))")

let wrong_answer = Coord.cartesian(size: schem.size)
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
                c.around.compactMap { schem.location(at: $0) }.map { schematic.value(at: $0) }
            }
            .reduce(0, +)
*/


var answer = 0
var inNumber = false
var hasSymbol = false
var currentValue = 0
for y in 0..<schem.size.y {
    for x in 0..<schem.size.x {
        let l = schem.locations[y][x]
        print("\(x) \(y) \(l) \(inNumber) \(hasSymbol)")
        if inNumber {
            switch l {
               case .number(let n):
                  currentValue = currentValue * 10 + n
                  if !hasSymbol {
                      print(Coord(x: x, y: y).around.compactMap { schem.location(at: $0) })
                      hasSymbol = Coord(x: x, y: y).around.compactMap { schem.location(at: $0) }.contains(where: Location.isSymbol)
                  }
               default:
                  if hasSymbol {
                      answer += currentValue
                  }
                  inNumber = false
                  currentValue = 0
                  hasSymbol = false
            }
        } else {
            switch l {
            case .number(let n):
                print(Coord(x: x, y: y).around.compactMap { schem.location(at: $0) })
               hasSymbol = Coord(x: x, y: y).around.compactMap { schem.location(at: $0) }.contains(where: Location.isSymbol)
               inNumber = true
               currentValue = n
            default:
               print("nothing")
            }
        }
    }
}

print("answer: \(answer)")

