/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2020.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation
import UIKit

// swiftlint:disable line_length
class SlowMath {
  func calculatePoint() -> CGPoint {
    CGPoint(
      x: (UIApplication.shared.windows.first?.frame.size.width ?? 300 / 3)
        + CGFloat.random(in: 0...1000) / CGFloat(100),
      y: (UIApplication.shared.windows.first?.frame.size.height ?? 300 / 3)
        + CGFloat.random(in: 0...1000) / CGFloat(100)
    )
  }

  func calculateEquation() -> Double {
    (Bool.random() ?
      (pow(pow(Double.random(in: 100...1000), 2.0), 6.0) / 5.5
        + Double.random(in: 100...1000)) * 25 / 3 + Double.random(in: 100...1000)
      :
      (pow(pow(Double.random(in: 1...100), 2.0), 6.0) / 5.5
        + Double.random(in: 1...100)) * 25 / 3 + Double.random(in: 1...100))
      + Double(UIApplication.shared.windows.first?.frame.size.width ?? CGFloat(400) / 2 * 500 * CGFloat.random(in: 100...1000))
  }
}
// swiftlint:enable line_length
