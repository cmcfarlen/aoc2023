import Foundation

func slurp(path: String) -> String {
    let url = URL(fileURLWithPath: path)
    do {
        return try String(contentsOf: url)
    } catch {
        fatalError("Failed to open: \(path)")
    }
}

enum Color {
    case red
    case green
    case blue
}

struct Sample {
    var redCount: Int
    var greenCount: Int
    var blueCount: Int

    init(redCount r: Int, greenCount g: Int, blueCount b: Int) {
        redCount = r
        greenCount = g
        blueCount = b
    }

    init() {
        redCount = 0
        greenCount = 0
        blueCount = 0
    }
}

struct Game {
    var id: Int
    var samples: [Sample]

    func checkCapable(with sample: Sample) -> Bool {
        samples.allSatisfy { s in
            s.redCount <= sample.redCount &&
            s.blueCount <= sample.blueCount &&
            s.greenCount <= sample.greenCount
        }
    }
}

func parseGame(input: String.SubSequence) -> Game {
    let colon = input.split(separator: ": ")
    let gameid = Int(colon[0].split(separator: " ")[1])
    let samples = colon[1].split(separator: "; ")
                     .map { s in
                        s.split(separator: ", ")
                          .reduce(Sample()) { sample, entry in
                             print(" entry \(entry)")
                             let parts = entry.split(separator: " ")
                             let count = Int(parts[0])!
                             let color = parts[1]
                             var copy = sample
                             switch color {
                                 case "red": copy.redCount = count
                                 case "green": copy.greenCount = count
                                 case "blue": copy.blueCount = count
                                 default: fatalError("unexpected color \(color)")
                             }
                             return copy
                          }
                     }

    return Game(id: gameid!, samples: samples)
}

let data = slurp(path: "day2.data")
let limit = Sample(redCount: 12, greenCount: 13, blueCount: 14)

let answer = data.split(separator: "\n")
     .map { line in
         parseGame(input: line)
     }
     .filter { $0.checkCapable(with: limit) }
     .map(\.id)
     .reduce(0, +)

print("answer: \(answer)")
