/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation
import CoreGraphics.CGBase

protocol Locatable {
  var location: CGPoint { get }
}

extension CGPoint: Locatable {
  var location: CGPoint { self }
}

struct QuadTree<Item: Locatable> {
  final class Node {
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
          Node(region: CGRect(x: region.origin.x, y: region.origin.y,
                              width: halfWidth, height: halfHeight))
        northEast =
          Node(region: CGRect(x: region.origin.x+halfWidth, y: region.origin.y,
                              width: halfWidth, height: halfHeight))
        southWest =
          Node(region: CGRect(x: region.origin.x, y: region.origin.y+halfHeight,
                              width: halfWidth, height: halfHeight))
        southEast =
          Node(region: CGRect(x: region.origin.x+halfWidth, y: region.origin.y+halfHeight,
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
    }

    let maxItemCapactiy = 10
    var region: CGRect
    var items: [Item] = []
    var quad: Quad?

    init(region: CGRect, items: [Item] = [], quad: Quad? = nil) {
      self.region = region
      self.quad = quad
      self.items = items
      self.items.reserveCapacity(maxItemCapactiy)
    }

    func copy() -> Node {
      Node(region: region, items: items, quad: quad?.copy())
    }

    @discardableResult
    func insert(_ item: Item) -> Bool {
      if let quad = quad {
        return quad.northWest.insert(item) ||
          quad.northEast.insert(item) ||
          quad.southWest.insert(item) ||
          quad.southEast.insert(item)
      }
      else {
        if items.count == maxItemCapactiy {
          subdivide()
          return insert(item)
        }
        else {
          guard region.contains(item.location) else {
            return false
          }
          items.append(item)
          return true
        }
      }
    }

    func subdivide() {
      precondition(quad == nil, "Can't subdivide a node already subdivided")
      quad = Quad(region: region)
    }

    func find(in searchRegion: CGRect) -> [Item] {
      guard region.intersects(searchRegion) else {
        return []
      }

      var found = items.filter { searchRegion.contains($0.location) }

      if let quad = quad {
        found += quad.all.flatMap { $0.find(in: searchRegion) }
      }

      return found
    }
  }

  var root: Node

  init(region: CGRect) {
    root = Node(region: region)
  }

  mutating func insert(_ item: Item) {
    if !isKnownUniquelyReferenced(&root) {
      root = root.copy()
    }
    root.insert(item)
  }

  func find(in searchRegion: CGRect) -> [Item] {
    root.find(in: searchRegion)
  }

  func allItems() -> [Item] {
    find(in: root.region)
  }

  private func collectRegions(from node: Node) -> [CGRect] {
    var results = [node.region]

    if let quad = node.quad {
      results += quad.all.flatMap { collectRegions(from: $0) }
    }
    return results
  }

  func allRegions() -> [CGRect] {
    collectRegions(from: root)
  }
}

typealias QuadTreeOfPoints = QuadTree<CGPoint>

private let itemCapacity = 10

indirect enum QuadTreeEnum<Item: Locatable> {

  case internalNode(region: CGRect, children: [Self])
  case node(region: CGRect, items: [Item])

  init(region: CGRect) {
    self = .node(region: region, items: [])
  }

  private init(region: CGRect, items: [Item]) {

    let halfWidth = region.size.width * 0.5
    let halfHeight = region.size.height * 0.5

    let children = [
      Self(region: CGRect(x: region.origin.x, y: region.origin.y,
                              width: halfWidth, height: halfHeight)),
      Self(region: CGRect(x: region.origin.x+halfWidth, y: region.origin.y,
                              width: halfWidth, height: halfHeight)),
      Self(region: CGRect(x: region.origin.x, y: region.origin.y+halfHeight,
                              width: halfWidth, height: halfHeight)),
      Self(region: CGRect(x: region.origin.x+halfWidth, y: region.origin.y+halfHeight,
                              width: halfWidth, height: halfHeight))
    ]
    self = .internalNode(region: region, children: children)

    items.forEach { self.insert($0) }
  }

  @discardableResult
  mutating func insert(_ item: Item) -> Bool {
    switch self {
    case .internalNode(region: let region,
                       children: var children):
      for index in children.indices {
        if children[index].insert(item) {
          self = .internalNode(region: region, children: children)
          return true
        }
      }
      return false
    case .node(region: let region, items: let items):
      guard region.contains(item.location) else {
        return false
      }
      if items.count == itemCapacity {
        self = Self(region: region, items: items)
        return insert(item)
      }
      else {
        self = .node(region: region, items: items + [item])
        return true
      }
    }
  }

  func find(in searchRegion: CGRect) -> [Item] {
    var found: [Item] = []

    switch self {
    case .internalNode(region: let region,
                       children: let children):
      guard region.intersects(searchRegion) else {
        return found
      }
      children.forEach { found.append(contentsOf: $0.find(in: region)) }
      return found

    case .node(region: let region, items: let items):
      guard region.intersects(searchRegion) else {
        return found
      }
      return items.filter { searchRegion.contains($0.location) }
    }
  }
}
