/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import CoreGraphics

/// Utility functions to make the math more clear.

@inlinable
func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

@inlinable
prefix func - (point: CGPoint) -> CGPoint {
  CGPoint(x: -point.x, y: -point.y)
}

@inlinable
func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  lhs + (-rhs)
}

@inlinable
func * (lhs: CGFloat, rhs: CGPoint) -> CGPoint {
  CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
}

@inlinable
func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
  CGPoint(x: rhs * lhs.x, y: rhs * lhs.y)
}

extension Collection where Element == CGPoint {
  func boundingRect() -> CGRect? {
    guard let start = self.first else {
      return nil
    }
    var minXY = start
    var maxXY = start
    dropFirst().forEach {
      minXY.x = Swift.min(minXY.x, $0.x)
      minXY.y = Swift.min(minXY.y, $0.y)
      maxXY.x = Swift.max(maxXY.x, $0.x)
      maxXY.y = Swift.max(maxXY.y, $0.y)
    }
    let size = CGSize(width: maxXY.x - minXY.x, height: maxXY.y - minXY.y)
    return CGRect(origin: minXY, size: size)
  }
}
