/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2021.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

func calculatePowers(_ number: Int) -> [Int]
{
  var results: [Int] = []
  var value = number
  for _ in 0...2 {
    value *= number
    results.append(value)
  }
  return results
}
calculatePowers(3) // [9, 27, 81]

let exampleList = [1, 2, 3, 4, 5]
let result = exampleList.map(calculatePowers(_:))
result.count // 5

let joinedResult = Array(result.joined())

let flatResult = exampleList.flatMap(calculatePowers(_:))
print(flatResult)
