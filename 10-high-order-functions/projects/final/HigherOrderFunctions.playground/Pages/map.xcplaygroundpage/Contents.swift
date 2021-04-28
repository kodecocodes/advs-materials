/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
var newNumbers: [Int] = []

for number in numbers {
  newNumbers.append(number * number)
}

print(newNumbers)

print("-----------------")

let newNumbers2 = numbers.map { $0 * $0 }
print(newNumbers2)

func squareOperation(value: Int) -> Int {
  print("Original Value is: \(value)")
  let newValue = value * value
  print("New Value is: \(newValue)")
  return newValue
}

print("-----------------")

let newNumbers3 = numbers.map(squareOperation(value:))
print(newNumbers3)
