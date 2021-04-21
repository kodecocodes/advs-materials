//: [Previous](@previous)

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
    var fValue = f(a)()
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
