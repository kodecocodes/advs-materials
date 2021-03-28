import Foundation

public struct PermutedCongruential: RandomNumberGenerator {
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
  public mutating func next() -> UInt64 {
    UInt64(next32()) << 32 | UInt64(next32())
  }
  public init(seed: UInt64) {
    state = seed &+ increment
    _ = next()
  }
}

public struct Point: Equatable {
  public var x, y: Double
}

public extension Point {
  static var zero: Point {
    Point(x: 0, y: 0)
  }
  
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

public enum Quadrant: CaseIterable, Hashable {
  case i, ii, iii, iv
  public init?(_ point: Point) {
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
