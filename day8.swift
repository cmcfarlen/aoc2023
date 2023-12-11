import Foundation
import Util

let data = slurp(path: "day8.data").split(separator: "\n")

let directions = data[0]

let map: [String:(String,String)] = data.dropFirst(1) // drop 1 because split omits empty by default
  .map { line in
    let name = line.prefix(3)
    let left = line.dropFirst(7).prefix(3)
    let right = line.dropFirst(12).prefix(3)

    return (String(name), (String(left), String(right)))
  }
  .reduce(into: [:]) { a, b in
    a[b.0] = b.1
  }

print(map)

var current = "AAA"
var steps = 0
repeat {
    for dir in directions {
        let n = map[current]!
        let next = if dir == "L" {
            n.0
        } else {
            n.1
        }

        print("\(current) -> \(next)")
        current = next
        steps += 1

        if current == "ZZZ" {
            break
        }
    }
} while current != "ZZZ"

print("steps: \(steps)")
