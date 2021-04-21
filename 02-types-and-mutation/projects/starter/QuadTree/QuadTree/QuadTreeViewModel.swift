/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI

enum Mode {
  case add, find
}

final class QuadTreeViewModel: ObservableObject {
  private var quadTree = QuadTree(region: CGRect(x: 0, y: 0, width: 1, height: 1))
  var windowSize: CGSize?
  @Published var mode: Mode = .add
  @Published var findWindow: CGRect?
  @Published var foundPoints: [CGPoint] = []

  var info: String {
    switch mode {
    case .add:
      return "Point Count \(pointCount)"
    case .find:
      return "Found \(foundPoints.count) of \(pointCount)"
    }
  }

  var points: [CGPoint] {
    quadTree.points()
  }

  var pointCount: Int {
    quadTree.count
  }

  // For diagnostics drawing
  var regions: [CGRect] {
    quadTree.regions()
  }

  func find(at point: CGPoint, searchSize: CGFloat) {
    guard let size = windowSize else {
      return
    }
    let searchSize2: CGFloat = searchSize / 2
    findWindow = CGRect(x: point.x, y: point.y, width: 0, height: 0)
        .insetBy(dx: -searchSize2, dy: -searchSize2)
    foundPoints = quadTree.find(in: CGRect(x: (point.x-searchSize2) / size.width,
                                           y: (point.y-searchSize2) / size.height,
                                           width: searchSize / size.width,
                                           height: searchSize / size.height))
  }

  func insert(_ point: CGPoint) {
    guard let size = windowSize else {
      return
    }
    objectWillChange.send()
    let x = point.x / size.width
    let y = point.y / size.height
    quadTree.insert(CGPoint(x: x, y: y))
  }

  func clear() {
    objectWillChange.send()
    quadTree = QuadTree(region: CGRect(x: 0, y: 0, width: 1, height: 1))
    findWindow = nil
    foundPoints = []
    mode = .add
  }
}
