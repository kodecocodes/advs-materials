/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2020.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

class SlowArray {
  func printArray() {
    let doubleArray = Array(repeating: 1.123, count: 100)
      .map { $0 * Double.random(in: 0 ..< 1000) }
    let intArray = Array(repeating: 1, count: 100)
      .map { $0 * Int.random(in: 0 ..< 1000) }
    let doubleMultiply = zip(doubleArray, intArray)
      .map { $0 * Double($1) }
    let sum = doubleMultiply.sorted()
      .map { $0 * 123 }
      .reduce(0, +)
    print(doubleMultiply)
    print(sum)
  }
}
