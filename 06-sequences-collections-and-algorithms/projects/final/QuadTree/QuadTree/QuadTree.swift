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

    let maxItemCapactiy = 1
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

    func insert(_ item: Item, path: [QuadPosition]) -> Index? {
      if let quad = quad {
        if let index = quad.northWest.insert(item, path: path + [.northWest]) {
          return index
        }
        else if let index = quad.northEast.insert(item, path: path + [.northEast]) {
          return index
        }
        else if let index = quad.southWest.insert(item, path: path + [.southWest]) {
          return index
        }
        else if let index = quad.southEast.insert(item, path: path + [.southEast]) {
          return index
        }
        else {
          return nil
        }
      }
      else {
        if items.count == maxItemCapactiy {
          subdivide()
          return insert(item, path: path)
        }
        else {
          guard region.contains(item.location) else {
            return nil
          }
          items.append(item)
          return Index(path: path, itemIndex: items.count-1)
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
    endIndex = Index(path: [], itemIndex: 0)
  }

  mutating func insert(_ item: Item) {
    if !isKnownUniquelyReferenced(&root) {
      root = root.copy()
    }
    if let insertedAt = root.insert(item, path: []) {
      let probe = index(after: insertedAt)
      if probe > endIndex {
        endIndex = probe
      }
    }
  }

  func find(in searchRegion: CGRect) -> [Item] {
    root.find(in: searchRegion)
  }

  func allItems() -> [Item] {
    Array(self)
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

  // MARK: - Collection conformance
  // Use a stored property for end index to keep access
  // to it O(1). Using a computed property would be O(log(N))
  // which would invalidate algorithm performance guarantees.
  private(set) var endIndex: Index
}

extension QuadTree: Collection {
  var startIndex: Index { Index(path: [], itemIndex: 0) }

  func index(after i: Index) -> Index {
    let node = findNode(for: i)
    if i.itemIndex < node.items.count-1 {
      return Index(path: i.path, itemIndex: i.itemIndex+1)
    }
    guard let quad = node.quad else {
      guard i.itemIndex < 2 else {
        fatalError("hhh")
      }
      return Index(path: i.path, itemIndex: i.itemIndex+1)
    }
    if !quad.northWest.items.isEmpty {
      return Index(path: i.path + [.northWest], itemIndex: 0)
    }
    else if !quad.northEast.items.isEmpty {
      return Index(path: i.path + [.northEast], itemIndex: 0)
    }
    else if !quad.southWest.items.isEmpty {
      return Index(path: i.path + [.southWest], itemIndex: 0)
    }
    else if !quad.southEast.items.isEmpty {
      return Index(path: i.path + [.southEast], itemIndex: 0)
    }
    return Index(path: i.path, itemIndex: i.itemIndex+1)
  }

  subscript(position: Index) -> Item {
    let node = findNode(for: position)
    return node.items[position.itemIndex]
  }

  enum QuadPosition: Int, Comparable {
    case northWest, northEast, southWest, southEast
    static func < (lhs: QuadPosition, rhs: QuadPosition) -> Bool {
      lhs.rawValue < rhs.rawValue
    }
  }

  struct Index: Comparable {
    var path: [QuadPosition]
    var itemIndex: Int

    static func < (lhs: Index, rhs: Index) -> Bool {
      var lhsIterator = lhs.path.makeIterator()
      var rhsIterator = rhs.path.makeIterator()
      var exhausted = false
      repeat {
        switch (lhsIterator.next(), rhsIterator.next()) {
        case let (left?, right?):
          guard left == right else {
            return left < right
          }
        case (nil, _?):
          return true
        case (_?, nil):
          return false
        case (nil, nil):
          exhausted = true
        }
      } while !exhausted
      return lhs.itemIndex < rhs.itemIndex
    }
  }

  func findNode(for index: Index) -> Node {
    index.path.reduce(root) { node, pathComponent in
      guard let quad = node.quad else {
        fatalError("invalid path - tree invariant violation")
      }
      switch pathComponent {
      case .northWest:
        return quad.northWest
      case .northEast:
        return quad.northEast
      case .southWest:
        return quad.southWest
      case .southEast:
        return quad.southEast
      }
    }
  }
}
