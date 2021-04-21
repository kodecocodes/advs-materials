/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2020.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

func doSomething() -> Substring {
    let largeString = "Lorem ipsum dolor sit amet"
    let index = largeString.firstIndex(of: " ") ?? largeString.endIndex
    return largeString[..<index]
}

let subString = doSomething()
subString.base

let newString = String(subString)
