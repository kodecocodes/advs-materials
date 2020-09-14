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
