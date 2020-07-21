/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
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
  // swiftlint:disable:next force_unwrapping
  String(String(value).map { toSuper[$0]! })
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
