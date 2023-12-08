import Foundation
import Util

struct LookupEntry {
    var destination: Range<Int>
    var source: Range<Int>
}

struct Lookup {
    var source: String
    var destination: String
    var lookup: [LookupEntry]

    init(from value: ArraySlice<Substring>) {
        let nameParts = value.first!.split(separator: " ")[0].split(separator: "-")
        source = String(nameParts[0])
        destination = String(nameParts[2])

        lookup = value.dropFirst()
        .map { line in
            line.split(separator: " ").map { Int($0)! }
        }
        .reduce(into: []) { lookup, desc in
            let destStart = desc[0]
            let srcStart = desc[1]
            let length = desc[2]

            lookup.append(LookupEntry(destination: destStart..<destStart+length, source: srcStart..<srcStart+length))

        }
    }

    func doLookup(_ v: Int) -> Int {
        for e in lookup {
            if e.source.contains(v) {
                let offset = v - e.source.lowerBound
                return e.destination.lowerBound + offset
            }
        }
        
        return v
    }

}

let data = slurp(path: "day5.example").split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: false)

print(data[0].split(separator: " ").dropFirst().map { Int($0)! }.partition(size: 2))

let seeds = data[0].split(separator: " ").dropFirst().map { Int($0)! }

let maps = data.dropFirst(2).split(separator: "")

let lookups = maps.map { Lookup(from: $0) }
                  .reduce(into: [:]) { result, l in
                    result[l.source] = l
                  }

func lookupAlmanac(using tables: [String:Lookup], seed s: Int) -> [(String,Int)] {
   var lookupType = "seed"
   var lookupValue = s
   var result = [(String,Int)]()

   result.append((lookupType, lookupValue))
   while let lookup = tables[lookupType] {
       lookupValue = lookup.doLookup(lookupValue)
       lookupType = lookup.destination
       result.append((lookupType, lookupValue))
   }
   return result
}

seeds.forEach { seed in
    let result = lookupAlmanac(using: lookups, seed: seed)
    print(result.map { (type, val) in "\(type) \(val)" }.joined(separator: ", "))
}

let answer = seeds.map { lookupAlmanac(using: lookups, seed: $0) }.map(\.last!.1).reduce(Int.max, min)
print("answer: \(answer)")

let seedRanges = data[0].split(separator: " ").dropFirst().map { Int($0)! }.partition(size: 2).map { $0[0]..<$0[0]+$0[1] }
print(seedRanges)


