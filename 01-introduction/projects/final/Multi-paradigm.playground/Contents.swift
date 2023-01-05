/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2023 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

let numbers = [1, 2, 4, 10, -1, 2, -10]

example("imperative") {
  var total = 0
  for value in numbers {
    total += value
  }
  print(total)
}

example("functional") {
  let total = numbers.reduce(0, +)
  print(total)
}

example("imperative, early-exit") {
  var total = 0
  for value in numbers {
    guard value >= 0 else { break }
    total += value
  }
  print(total)
}

example("imperative, early-exit with just-in-time mutability") {
  func sumWhilePositive(_ numbers: [Int]) -> Int {
    var total = 0
    for value in numbers {
      guard value >= 0 else { break }
      total += value
    }
    return total
  }

  let total = sumWhilePositive(numbers)
  print(total)
}

example("functional, early-exit") {
  let total = numbers
                .prefix { $0 >= 0 }
                .reduce(0, +)
  print(total)
}

