/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

func wordsToInt(_ str: String) -> Int? {
  let formatter = NumberFormatter()
  formatter.numberStyle = .spellOut
  return formatter.number(from: str.lowercased()) as? Int
}

wordsToInt("Three")
wordsToInt("Four")
wordsToInt("Five")
wordsToInt("Hello")


//func convertToInt(_ value: Any) -> Int? {
//  if let value = value as? String {
//    return wordsToInt(value)
//  } else {
//    return value as? Int
//  }
//}

func convertToInt(_ value: Any) -> Int? {
  if let value = value as? String {
    return wordsToInt(value)
  } else if let value = value as? Double {
    return Int(value)
  } else {
    return value as? Int
  }
}

convertToInt("one")
convertToInt(1.1)
convertToInt(1)

let sampleArray: [Any] = [1, 2, 3.0, "Four", "Five", "sixx", 7.1, "Hello", "World", "!"]

let newArray = sampleArray.compactMap(convertToInt(_:)) // [1, 2, 4, 5]
print(newArray)
