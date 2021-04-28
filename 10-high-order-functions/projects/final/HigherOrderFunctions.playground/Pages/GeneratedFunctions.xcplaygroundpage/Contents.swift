/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

func flip<A, C>(
  _ originalMethod: @escaping (A) -> () -> C
) -> () -> (A) -> C {
  return { { a in originalMethod(a)() } }
}

extension Int {
  func word() -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.string(from: self as NSNumber)
  }
}

1.word() // one
10.word() // ten
36.word() // thirty-six

Int.word // (Int) -> () -> Optional<String>

Int.word(1)() // one
Int.word(10)() // ten
Int.word(36)() // thirty-six

flip(Int.word)()(1) // one

var flippedWord = flip(Int.word)()

[1, 2, 3, 4, 5].map(
  flippedWord
)

func reduce<A, C>(
  _ originalMethod: @escaping (A) -> () -> C
) -> (A) -> C {
  return { a in originalMethod(a)() }
}

var reducedWord = reduce(Int.word)
