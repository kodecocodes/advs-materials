/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

func doSomething() -> Substring {
  let largeString = "Lorem ipsum dolor sit amet"
  let index = largeString.firstIndex(of: " ") ?? largeString.endIndex
  return largeString[..<index]
}

let subString = doSomething()
subString.base

let newString = String(subString)
