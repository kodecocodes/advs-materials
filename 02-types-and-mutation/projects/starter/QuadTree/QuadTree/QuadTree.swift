/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation
import CoreGraphics.CGBase // CGPoint

struct QuadTree {
  private(set) var count = 0

  init(region: CGRect) {
  }

  @discardableResult
  mutating func insert(_ point: CGPoint) -> Bool {
    false
  }

  func find(in searchRegion: CGRect) -> [CGPoint] {
    []
  }

  func points() -> [CGPoint] {
    []
  }

  func regions() -> [CGRect] {
    []
  }
}
