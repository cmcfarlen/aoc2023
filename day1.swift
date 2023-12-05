import Foundation
import Util

func part1(_ data: String) -> Int {
    return data.split(separator: "\n")
        .map { line in
            line.filter { ch in
                ch.isNumber
            }
        }
        .map { line in
            String([line.first!, line.last!])
        }
        .map { line in
            Int(line)!
        }
        .reduce(0, +)
}

let words: [String:Character] = [
"1": "1", "2": "2", "3": "3", "4": "4", "5": "5", "6": "6", "7": "7", "8": "8", "9": "9",
"one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9"
]

func firstDigit(word: any StringProtocol) -> Character? {
    var w = String(word)
    while !w.isEmpty {
        for (k, v) in words {
            if w.starts(with: k) {
                return v
            }
        }
        w = String(w.dropFirst())
    }
    return "N"
}

func lastDigit(word: any StringProtocol) -> Character? {
    let end = word.endIndex
    var start = word.index(before: end)

    while start != word.startIndex {
        let sw = word[start..<end]
        for (k, v) in words {
            print("checking \(sw) \(k)")
            if sw.starts(with: k) {
                return v
            }
        }
        start = word.index(before: start)
    }
    for (k, v) in words {
        print("checking \(word) \(k)")
        if word.starts(with: k) {
            return v
        }
    }
    return "N"
}

func part2(_ data: String) -> Int {
    return data.split(separator: "\n")
      .map { line in
         String([firstDigit(word: line)!, lastDigit(word: line)!])
      }
    .map { line in
        Int(line)!
    }
    .reduce(0, +)
}

let data = slurp(path: "day1.data")

//print("part1: \(part1(data))")
print("part2: \(part2(data))")

//let testwords = ["eight", "4blahonezz"]
//for word in testwords {
//    print("\(word) \(firstDigit(word: word)!) \(lastDigit(word: word)!)")
//}

    
