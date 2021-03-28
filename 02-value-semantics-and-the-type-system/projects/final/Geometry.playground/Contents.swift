/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

struct StructPoint {
  var x, y: Double
}

class ClassPoint {
  var x, y: Double
  init(x: Double, y: Double) { (self.x, self.y) = (x, y) }
}

let structPointA = StructPoint(x: 0, y: 0)
var structPointB = structPointA
structPointB.x += 10
print(structPointA.x) // not affected, prints 0.0

let classPointA = ClassPoint(x: 0, y: 0)
let classPointB = classPointA
classPointB.x += 10
print(classPointA.x) // affected, prints 10.0

struct Point: Equatable {
  var x, y: Double
}
struct Size: Equatable {
  var width, height: Double
}
struct Rectangle: Equatable {
  var origin: Point
  var size: Size
}

extension Point {
  func flipped() -> Self {
    Point(x: y, y: x)
  }
  mutating func flip() {
    self = flipped()
  }
}

extension Point {
  static var zero: Point {
    Point(x: 0, y: 0)
  }
  static func random(inRadius radius: Double) -> Point {
    guard radius >= 0 else {
      return .zero
    }
    let x = Double.random(in: -radius ... radius)
    let maxY = (radius * radius - x * x).squareRoot()
    let y = Double.random(in: -maxY ... maxY)
    return Point(x: x, y: y)
  }
}

struct PermutedCongruential: RandomNumberGenerator {
  private var state: UInt64
  private let multiplier: UInt64 = 6364136223846793005
  private let increment: UInt64 = 1442695040888963407
  private func rotr32(x: UInt32, r: UInt32) -> UInt32 {
    (x &>> r) | x &<< ((~r &+ 1) & 31)
  }
  private mutating func next32() -> UInt32 {
    var x = state
    let count = UInt32(x &>> 59)
    state = x &* multiplier &+ increment
    x ^= x &>> 18
    return rotr32(x: UInt32(truncatingIfNeeded: x &>> 27),
                  r: count)
  }
  mutating func next() -> UInt64 {
    UInt64(next32()) << 32 | UInt64(next32())
  }
  init(seed: UInt64) {
    state = seed &+ increment
    _ = next()
  }
}

extension Point {
  static func random(inRadius radius: Double,
                     using randomSource:
                      inout PermutedCongruential) -> Point {
    guard radius >= 0 else {
      return .zero
    }
    let x = Double.random(in: -radius...radius,
                          using: &randomSource)
    let maxY = (radius * radius - x * x).squareRoot()
    let y = Double.random(in: -maxY...maxY,
                          using: &randomSource)
    return Point(x: x, y: y)
  }
}

var pcg = PermutedCongruential(seed: 1234)
for _ in 1...10 {
  print(Point.random(inRadius: 1, using: &pcg))
}

enum Quadrant: CaseIterable, Hashable {
  case i, ii, iii, iv
  init?(_ point: Point) {
    guard !point.x.isZero && !point.y.isZero else {
      return nil
    }
    switch (point.x.sign, point.y.sign) {
    case (.plus, .plus):
      self = .i
    case (.minus, .plus):
      self = .ii
    case (.minus, .minus):
      self = .iii
    case (.plus, .minus):
      self = .iv
    }
  }
}

Quadrant(Point(x: 10, y: -3)) // evaluates to .iv
Quadrant(.zero) // evaluates to nil

let a = Measurement(value: .pi/2,
                    unit: UnitAngle.radians)
let b = Measurement(value: 90,
                    unit: UnitAngle.degrees)
a + b  // 180 degrees

typealias Angle = Measurement<UnitAngle>

func sin(_ angle: Angle) -> Double {
  sin(angle.converted(to: .radians).value)
}
sin(a)  // 1
sin(b)  // 1

