import Foundation
import Util

enum CardValue : Comparable {
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
    case ace

    init(ch value: Character) {
        switch value {
            case "2": self = .two
            case "3": self = .three
            case "4": self = .four
            case "5": self = .five
            case "6": self = .six
            case "7": self = .seven
            case "8": self = .eight
            case "9": self = .nine
            case "T": self = .ten
            case "J": self = .jack
            case "Q": self = .queen
            case "K": self = .king
            case "A": self = .ace
            default: fatalError("unknown card value \(value)")
        }
    }
}

extension CardValue : CustomStringConvertible
{
    var description: String {
        switch self {
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            case .five: return "5"
            case .six: return "6"
            case .seven: return "7"
            case .eight: return "8"
            case .nine: return "9"
            case .ten: return "T"
            case .jack: return "J"
            case .queen: return "Q"
            case .king: return "K"
            case .ace: return "A"
        }
    }
}

enum HandType: Comparable {
    case highCard
    case onePair
    case twoPair
    case threeOfAKind
    case fullHouse
    case fourOfAKind
    case fiveOfAKind
}

struct Hand {
    var hand: [CardValue]
    var handType: HandType {
        let f = hand.frequencies
        let max = f.map(\.1).reduce(0, max)
        switch f.count {
            case 1: return .fiveOfAKind
            case 2: 
                if max == 4 {
                    return .fourOfAKind
                } else {
                    return .fullHouse
                }
            case 3:
                if max == 3 {
                    return .threeOfAKind
                } else {
                    return .twoPair
                }
            case 4:
                return .onePair
            default:
                return .highCard
        }
    }

}

extension Hand: Comparable {
    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.handType == rhs.handType {
            for i in 0..<5 {
                if lhs.hand[i] != rhs.hand[i] {
                    return if lhs.hand[i] < rhs.hand[i] {
                        true
                    } else {
                        false
                    }

                }
            }
            return false
        }
        return lhs.handType < rhs.handType
    }

    static func == (lhs: Hand, rhs: Hand) -> Bool {
        return lhs.hand == rhs.hand
    }
}

extension Hand: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        hand = value.map { cardValue($0) }
    }
}

extension Hand: CustomStringConvertible {
    var description: String {
        hand.map(\.description).joined()
    }
}

func cardValue(_ ch: Character) -> CardValue {
    return CardValue(ch: ch)
}


assert(cardValue("A") == .ace)
assert(cardValue("T") == .ten)

assert(("33322" as Hand).handType == .fullHouse)

["KKKK2" as Hand,
 "22222"]
 .forEach { h in
 print(h, h.handType)
 }

[("KKKK2" as Hand, "KKKK3" as Hand),
 ("22345", "33543"),
 ]
 .forEach { (lhs, rhs) in
   assert( lhs < rhs )
 }

let sorted = ["KKKKK" as Hand, "KKAAA", "KKJJJ", "QJQJA", "23456"].sorted()
print(sorted)


let data = slurp(path: "day7.data").split(separator: "\n")
let hands = data.map { entry in
    let parts = entry.split(separator: " ")
    let hand = Hand(stringLiteral: String(parts[0]))
    let bid = Int(parts[1])!

    return (hand, bid)
}

let answer = hands.sorted { $0.0 < $1.0 }.map(\.1)
    .enumerated()
    .map { (idx, bid) in (idx+1) * bid }
.reduce(0, +)

print("answer: \(answer)")


