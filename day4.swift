import Foundation
import Util

let data = slurp(path: "day4.data")

struct Card {
    var id: Int
    var winning: Set<Int>
    var numbers: [Int]

    var matches: [Int] {
        numbers.filter { winning.contains($0) }
    }

    var score: Decimal {
        guard matches.count > 0 else {
            return 0
        }
        return pow(2, matches.count - 1)
    }

    init(_ value: any StringProtocol) {
        let parts = value.split(separator: ": ")
        let card = parts[0].split(separator: " ")
        id = Int(card[1])!

        let game = parts[1].split(separator: " | ")
        winning = game[0].split(separator: " ").reduce(into: Set<Int>()) { s, v in
           s.insert(Int(v)!)
        }
        numbers = game[1].split(separator: " ").map { Int($0)! }
    }

}


let cards = data.split(separator: "\n").map { Card($0) }

cards.forEach { c in
   print("card \(c.id): \(c.matches) \(c.score)")
}

let answer = cards.map(\.score).reduce(0, +)
print("answer: \(answer)")
