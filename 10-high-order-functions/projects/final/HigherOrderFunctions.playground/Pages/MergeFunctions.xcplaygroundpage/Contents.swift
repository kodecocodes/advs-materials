/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

extension Int {
  func word() -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.string(from: self as NSNumber)
  }

  func squared() -> Int {
    return self * self
  }

  func squareAndWord() -> String? {
    self.squared().word()
  }
}

func mergeFunctions<A, B, C>(
  _ f: @escaping (A) -> () -> B,
  _ g: @escaping (B) -> () -> C
) -> (A) -> C {
  return { a in
    let fValue = f(a)()
    return g(fValue)()
  }
}

var mergedFunctions = mergeFunctions(Int.squared, Int.word)
mergedFunctions(2)

func +<A, B, C>(
  left: @escaping (A) -> () -> B,
  right: @escaping (B) -> () -> C
) -> (A) -> C {
  return { a in
    let leftValue = left(a)()
    return right(leftValue)()
  }
}

var addedFunctions = Int.squared + Int.word
addedFunctions(2)
(Int.squared + Int.word)(2)
