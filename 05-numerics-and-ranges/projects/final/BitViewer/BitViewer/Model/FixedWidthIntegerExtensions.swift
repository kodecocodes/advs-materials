/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

/// Model a particular bit in a fixed width integer.
struct FixedWidthIntegerBit: Identifiable {
  let id: Int  ///< Index of the bit in a word with LSB == 0
  let value: Bool
  var string: String {
    String(value ? "1" : "0")
  }
}

extension FixedWidthInteger {
  /// Grab the bits from any fixed width type.
  var bits: [FixedWidthIntegerBit] {
    (0 ..< bitWidth).reversed().map { (index: Int) -> FixedWidthIntegerBit in
      FixedWidthIntegerBit(id: index, value: (0x1 << index) & self != 0)
    }
  }

  /// Split the bits into bytes (groups of 8)
  var bytesOfBits: [[FixedWidthIntegerBit]] {
    var bytes: [[FixedWidthIntegerBit]] = []
    var consume = self.bits

    while !consume.isEmpty {
      bytes.append(Array(consume.prefix(8)))
      consume = Array(consume.dropFirst(8))
    }

    return bytes
  }
}
