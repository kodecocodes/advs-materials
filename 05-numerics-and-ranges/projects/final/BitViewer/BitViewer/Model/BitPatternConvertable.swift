/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import CoreGraphics // CGFloat

// Float and Double are aliases

// Notably Float80 doesn't have a FixedWidthInteger that is able
// to represent it.  Conforming this protocol would take some effort.
// Since your main goal is to learn about IEEE 754, we won't worry
// about supporting this extended type.

protocol BitPatternConvertable {
  associatedtype BitPattern: FixedWidthInteger
  init(bitPattern: BitPattern)
  var bitPattern: BitPattern { get }
}

extension Float64: BitPatternConvertable {}
extension Float32: BitPatternConvertable {}
extension Float16: BitPatternConvertable {}
extension CGFloat: BitPatternConvertable {}

protocol DoubleConvertable {
  init(_ double: Double)
  func asDouble() -> Double
}

extension Float64: DoubleConvertable {
  func asDouble() -> Double { Double(self) }
}
extension Float32: DoubleConvertable {
  func asDouble() -> Double { Double(self) }
}
extension Float16: DoubleConvertable {
  func asDouble() -> Double { Double(self) }
}
extension CGFloat: DoubleConvertable {
  func asDouble() -> Double { Double(self) }
}
