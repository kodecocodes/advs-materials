/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

/// A simple abstraction for keeping a ring buffer of equatable  values.
/// You can check to see if one of the values was added, but the memory.
/// It only remembers the number of values
struct RingMemory<Element: Equatable> {
  private var elements: [Element?]
  private var addIndex: Int = 0

  /// Initialize RingMemory with capacity that specifies how many objects
  /// to remember.
  init(capacity: Int) {
    precondition(capacity > 0, "capacity must be greater than zero")
    elements = Array(repeating: nil, count: capacity)
  }

  /// Returns true if the element has been seen recently (specified by capacity)
  func contains(_ element: Element) -> Bool {
    elements.first { $0 == element } != nil
  }

  /// Adds a new element, potentially forgets an older one, controlled by capacity.
  mutating func add(_ element: Element) {
    elements[addIndex] = element
    addIndex = (addIndex+1) % elements.count
  }

  /// Resets what has been seen.
  mutating func reset() {
    elements = Array(repeating: nil, count: elements.count)
    addIndex = 0
  }
}
