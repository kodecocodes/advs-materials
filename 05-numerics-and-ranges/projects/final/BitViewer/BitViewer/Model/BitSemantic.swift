/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

enum BitSemantic: CaseIterable {
  case sign
  case exponent
  case significand

  static func provider<IntType: FixedWidthInteger>(for int: IntType.Type) -> (Int) -> Self? {
    return {
      bitIndex in
      int.isSigned && bitIndex == int.bitWidth - 1 ? .sign : nil
    }
  }

  static func provider<FloatType: BinaryFloatingPoint>(for floatType: FloatType.Type) -> (Int) -> Self {
    return { bitIndex in
      if bitIndex < FloatType.significandBitCount {
        return .significand
      } else if bitIndex < FloatType.significandBitCount + FloatType.exponentBitCount {
        return .exponent
      } else {
        return .sign
      }
    }
  }
}
