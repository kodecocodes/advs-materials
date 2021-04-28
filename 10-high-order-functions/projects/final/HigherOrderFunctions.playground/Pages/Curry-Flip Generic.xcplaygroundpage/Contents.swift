/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

func someOperation(_ p1: Int, _ p2: String) {
  let str = "number is: \(p1), and String is: \(p2)"
  print(str)
}

func aHigherOrderFunction(_ operation: (Int) -> ()) {
  let numbers = 1...10
  numbers.forEach(operation)
}

func curry<A, B, C>(
  _ originalMethod: @escaping (A, B) -> C
) -> (A) -> (B) -> C {
  return { a in
    { b in
      originalMethod(a,b)
    }
  }
}

//someOperation(1, "number one")
//curry(someOperation)(1)("number one")

someOperation
curry(someOperation)

func flip<A, B, C>(
  _ originalMethod: @escaping (A) -> (B) -> C
) -> (B) -> (A) -> C {
  return { b in { a in originalMethod(a)(b) } }
}

flip(curry(someOperation))

aHigherOrderFunction(flip(curry(someOperation))("a constant"))
