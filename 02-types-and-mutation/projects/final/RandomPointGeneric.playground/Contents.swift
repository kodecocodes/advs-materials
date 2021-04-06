/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

extension Point {
  static func random<G: RandomNumberGenerator>(inRadius radius: Double,
                     using randomSource:
                      inout G) -> Point {
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

  static func random(inRadius radius: Double) -> Point {
    var system = SystemRandomNumberGenerator()
    return random(inRadius: radius, using: &system)
  }
}

print(Point.random(inRadius: 1))

var source = PermutedCongruential(seed: 1222)
print(Point.random(inRadius: 1, using: &source))
