/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift
///

import SwiftUI

private let toSuper: [Character: Character] =
  [
    "0": "\u{2070}",
    "1": "\u{00B9}",
    "2": "\u{00B2}",
    "3": "\u{00B3}",
    "4": "\u{2074}",
    "5": "\u{2075}",
    "6": "\u{2076}",
    "7": "\u{2077}",
    "8": "\u{2078}",
    "9": "\u{2079}",
    "-": "\u{207B}"
  ]

func superscript(_ value: Int) -> String {
  String(String(value).map { toSuper[$0] ?? Character("") })
}

private extension FixedWidthInteger {
  var hexString: String {
    (self < 0 ? "-0x" : "0x") + String(self.magnitude, radix: 16).uppercased()
  }

  var powersOfTwoExpansion: String? {
    let negativeTerm = self < 0 ? ["-2\(superscript(bitWidth - 1))"] : []
    let magnitudeBits = Self.isSigned ? Array(bits.dropFirst()) : bits
    let terms = magnitudeBits.reduce(negativeTerm) { result, bit in
      bit.value ? result + ["2\(superscript(bit.id))"] : result
    }
    return terms.isEmpty ? nil :
      terms.joined(separator: " + ") + " = \(self) = \(self.hexString)"
  }

  var evaluatedExpansion: String? {
    let negativeTerm = self < 0 ? [Self.min] : []
    let magnitudeBits = Self.isSigned ? Array(bits.dropFirst()) : bits
    let terms = magnitudeBits.reduce(negativeTerm) { result, bit in
      bit.value ? result + [Self(1) << bit.id] : result
    }
    return terms.isEmpty ? nil :
      terms.map(String.init).joined(separator: " + ") + " = \(self) = \(self.hexString)"
  }
}

struct IntegerValueExpansionView<IntType: FixedWidthInteger>: View {
  enum Kind { case powersOfTwo, evaluated }
  let value: IntType
  let kind: Kind

  var body: some View {
    if let expansion = kind == .powersOfTwo ? value.powersOfTwoExpansion : value.evaluatedExpansion {
      Text(expansion)
    } else {
      Text("= 0").hidden() // placeholder spacing when the value is zero
    }
  }
}
