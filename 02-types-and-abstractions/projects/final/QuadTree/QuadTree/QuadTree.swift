/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2023 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import Foundation
import CoreGraphics.CGBase // CGPoint

struct QuadTree: Sendable {
  private final class Node: @unchecked Sendable {
    let maxItemCapacity = 4
    var region: CGRect
    var points: [CGPoint] = []
    var quad: Quad?

    init(region: CGRect, points: [CGPoint] = [], quad: Quad? = nil) {
      self.region = region
      self.quad = quad
      self.points = points
      self.points.reserveCapacity(maxItemCapacity)
      precondition(points.count <= maxItemCapacity)
    }

    struct Quad {
      var northWest: Node
      var northEast: Node
      var southWest: Node
      var southEast: Node

      var all: [Node] { [northWest, northEast, southWest, southEast] }

      init(region: CGRect) {
        let halfWidth = region.size.width * 0.5
        let halfHeight = region.size.height * 0.5

        northWest =
          Node(region: CGRect(x: region.origin.x,
                              y: region.origin.y,
                              width: halfWidth, height: halfHeight))
        northEast =
          Node(region: CGRect(x: region.origin.x + halfWidth,
                              y: region.origin.y,
                              width: halfWidth, height: halfHeight))
        southWest =
          Node(region: CGRect(x: region.origin.x,
                              y: region.origin.y + halfHeight,
                              width: halfWidth, height: halfHeight))
        southEast =
          Node(region: CGRect(x: region.origin.x + halfWidth,
                              y: region.origin.y + halfHeight,
                              width: halfWidth, height: halfHeight))
      }

      init(northWest: Node, northEast: Node,
           southWest: Node, southEast: Node) {
        self.northWest = northWest
        self.northEast = northEast
        self.southWest = southWest
        self.southEast = southEast
      }

      func copy() -> Quad {
        Quad(northWest: northWest.copy(),
             northEast: northEast.copy(),
             southWest: southWest.copy(),
             southEast: southEast.copy())
      }
    } // End of Quad

    func copy() -> Node {
      Node(region: region, points: points, quad: quad?.copy())
    }

    func subdivide() {
      precondition(quad == nil, "Can't subdivide a node already subdivided")
      quad = Quad(region: region)
    }

    func insert(_ point: CGPoint) -> Bool {
      guard region.contains(point) else {
        return false
      }
      
      if let quad = quad {
        return quad.northWest.insert(point) ||
          quad.northEast.insert(point) ||
          quad.southWest.insert(point) ||
          quad.southEast.insert(point)
      }
      else {
        if points.count == maxItemCapacity {
          subdivide()
          return insert(point)
        }
        else {
          points.append(point)
          return true
        }
      }
    }

    func find(in searchRegion: CGRect) -> [CGPoint] {
      guard region.intersects(searchRegion) else {
        return []
      }
      var found = points.filter { searchRegion.contains($0) }
      if let quad = quad {
        found += quad.all.flatMap { $0.find(in: searchRegion) }
      }
      return found
    }
  } // End of Node

  private var root: Node
  private(set) var count = 0

  init(region: CGRect, points: [CGPoint] = []) {
    root = Node(region: region)
    for point in points {
      insert(point)
    }
  }

  @discardableResult
  mutating func insert(_ point: CGPoint) -> Bool {
    if !isKnownUniquelyReferenced(&root) {
      root = root.copy()
    }
    guard root.insert(point) else {
      return false
    }
    count += 1
    return true
  }

  func find(in searchRegion: CGRect) -> [CGPoint] {
    root.find(in: searchRegion)
  }

  func points() -> [CGPoint] {
    find(in: root.region)
  }

  private func collectRegions(from node: Node) -> [CGRect] {
    var results = [node.region]
    if let quad = node.quad {
      results += quad.all.flatMap { collectRegions(from: $0) }
    }
    return results
  }

  func regions() -> [CGRect] {
    collectRegions(from: root)
  }
}
