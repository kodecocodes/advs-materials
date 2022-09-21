/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

func intToWord(_ number: Int) -> String? {
  let formatter = NumberFormatter()
  formatter.numberStyle = .spellOut
  return formatter.string(from: number as NSNumber)
}

let numbers: [Int] = Array(0...100)
let words = numbers.compactMap(intToWord(_:))
print(words)

func shouldKeep(word: String) -> Bool {
  return word.count == 4
}

let filteredWords = words.filter(shouldKeep(word:))
//let filteredWords = words.filter { $0.count == 4 }
