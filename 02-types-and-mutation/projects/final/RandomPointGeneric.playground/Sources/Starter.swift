import Foundation

public struct Point: Equatable {
  var x, y: Double
  public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
}

extension Point {
  public static var zero: Point {
    Point(x: 0, y: 0)
  }
}

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
