//
//  UUIDv7.swift
//  Wara
//
//  Created by Meow on 30/10/25.
//

import Foundation

enum UUIDv7 {
    /// Generate a UUIDv7 (RFC 9562 inspired) following the provided JS algorithm.
    static func generate() -> String {
        // Current time in ms since Unix epoch, padded to 12 hex chars (48-bit)
        let nowMs = UInt64(Date().timeIntervalSince1970 * 1000)
        let timeHex = String(format: "%012llx", nowMs)

        let timeHigh = String(timeHex.prefix(8))
        let timeLow = String(timeHex.dropFirst(8).prefix(4))

        // Generate 20 random hex digits (as characters)
        var randomHex: [Character] = []
        randomHex.reserveCapacity(20)
        for _ in 0..<20 {
            let nibble = Int.random(in: 0...15)
            let ch = String(format: "%x", nibble).first!
            randomHex.append(ch)
        }

        // Compute variant nibble from random[3]: (val & 0x3) | 0x8, then hex
        let r3Val = Int(String(randomHex[3]), radix: 16) ?? 0
        let variantVal = (r3Val & 0x3) | 0x8
        let variantNibble = String(format: "%x", variantVal)

        // Assemble groups: 8-4-4-4-12
        let group3 = "7" + String(randomHex[0]) + String(randomHex[1]) + String(randomHex[2])
        let group4 = variantNibble + String(randomHex[4]) + String(randomHex[5]) + String(randomHex[6])
        let group5 = randomHex[7...18].map { String($0) }.joined()

        return [timeHigh, timeLow, group3, group4, group5].joined(separator: "-")
    }
}