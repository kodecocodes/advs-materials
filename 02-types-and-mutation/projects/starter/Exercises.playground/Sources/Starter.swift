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

public typealias Angle = Measurement<UnitAngle>

public extension Angle {
  init(radians: Double) {
    self = Angle(value: radians, unit: .radians)
  }
  init(degrees: Double) {
    self = Angle(value: degrees, unit: .degrees)
  }
  var radians: Double {
    converted(to: .radians).value
  }
  var degrees: Double {
    converted(to: .degrees).value
  }
}

public func cos(_ angle: Angle) -> Double {
  cos(angle.radians)
}
public func sin(_ angle: Angle) -> Double {
  sin(angle.radians)
}

public struct Polar: Equatable {
  public init(angle: Angle, distance: Double) {
    self.angle = angle
    self.distance = distance
  }

  public var angle: Angle
  public var distance: Double
}

// Convert polar-coordinates to xy-coordinates
public extension Point {
  init(_ polar: Polar) {
    self = Point(x: polar.distance * cos(polar.angle),
                 y: polar.distance * sin(polar.angle))
  }
}

// Convert xy coordinates to polar coordinates
public extension Polar {
  init(_ point: Point) {
    self = Polar(angle: Angle(radians: atan2(point.y, point.x)),
                 distance: hypot(point.x, point.y))
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
