/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

func aHigherOrderFunction(_ operation: (Int) -> ()) {
  let numbers = 1...10
  numbers.forEach(operation)
}

func someOperation(_ p1: Int, _ p2: String) {
  print("number is: \(p1), and String is: \(p2)")
}

func curried_SomeOperation(_ str: String) -> (Int) -> ()
{
  return { p1 in
    print("number is: \(p1), and String is: \(str)")
  }
}

//aHigherOrderFunction { curried_SomeOperation("a constant")($0) }

aHigherOrderFunction(curried_SomeOperation("a constant"))
