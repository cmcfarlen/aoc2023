
import Foundation
import Util

let data = slurp(path: "day6.data")

let rows = data.split(separator: "\n").map { $0.split(separator: " ") }.map { $0.dropFirst() }.map { $0.map { Int(String($0))! } }

let races = zip(rows[0], rows[1])

func waysToWin(time: Int, distance: Int) -> Int {
    return (1..<time).map { ($0, (time - $0) * $0) }.filter { (_, dist) in dist > distance }.count
}

let answer = races.map { (time, distance) in
    waysToWin(time: time, distance: distance)
}.reduce(1, *)

print(answer)


