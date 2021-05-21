/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

struct FizzBuzz: Collection {
  typealias Index = Int

  var startIndex: Index { 1 }
  var endIndex: Index { 101 }

  // Actually not needed because of RandomAccessCollection conformance
  // and because Index is a Strideable (Int)
//  func index(after i: Index) -> Index {
//    print("Calling \(#function) with \(i)")
//    return i + 1
//  }

  subscript (index: Index) -> String {
    precondition(indices.contains(index), "out of 1-100")
    switch (index.isMultiple(of: 3), index.isMultiple(of: 5)) {
    case (false, false):
      return String(index)
    case (true, false):
      return "Fizz"
    case (false, true):
      return "Buzz"
    case (true, true):
      return "FizzBuzz"
    }
  }
}

// Actually not needed because FizzBuzz is RandomAccessCollection and
// the index is Strideable (Int).
extension FizzBuzz: BidirectionalCollection {
  func index(before i: Index) -> Index {
    print("Calling \(#function) with \(i)")
    return i - 1
  }
}

/*
// MARK: -

let fizzBuzz = FizzBuzz()
for value in fizzBuzz {
  print(value, terminator: " ")
}
print()

// MARK: -

let fizzBuzzPositions =
  fizzBuzz.enumerated().reduce(into: []) { list, item in
    if item.element == "FizzBuzz" {
      list.append(item.offset + fizzBuzz.startIndex)
    }
  }

print(fizzBuzzPositions)
*/

extension FizzBuzz: RandomAccessCollection {
}

let fizzBuzz = FizzBuzz()
print(fizzBuzz.dropLast(40).count)

// MARK: - Slices

let slice = fizzBuzz[20...30]
slice.startIndex
slice.endIndex
slice.count
for item in slice.enumerated() {
  print("\(item.offset):\(item.element)", terminator: " ")
}
print("")

let sliceOfSlice = slice[22...24]
sliceOfSlice.startIndex
sliceOfSlice[sliceOfSlice.startIndex]

// MARK: - Allocation of Slices

let numbers = Array(0..<100)
let upper = numbers[(numbers.count/2)...]
let upperArray = Array(upper)


// MARK: - Eager vs Lazy

let firstThree = FizzBuzz()
  .compactMap(Int.init)
  .filter { $0.isMultiple(of: 2) }
  .prefix(3)

print(firstThree)

let firstThreeLazy = FizzBuzz()
  .lazy
  .compactMap(Int.init)
  .filter { $0.isMultiple(of: 2) }
  .prefix(3)

print(Array(firstThreeLazy))

// MARK: - Making an algorithm generic

let values: [Int] = [1, 3, 4, 1, 3, 4, 7, 5]

/*
extension Array {
  func chunks(ofCount chunkCount: Int) -> [[Element]] {
    var result: [[Element]] = []
    for index in stride(from: 0, to: count, by: chunkCount) {
      let lastIndex = Swift.min(count, index + chunkCount)
      result.append(Array(self[index ..< lastIndex]))
    }
    return result
  }
}

values.chunks(ofCount: 3)
*/

// A more generic version

extension Collection {
  func chunks(ofCount chunkCount: Int) -> [SubSequence] {
    var result: [SubSequence] = []
    result.reserveCapacity(count / chunkCount + (count % chunkCount).signum())
    var idx = startIndex
    while idx < endIndex {
      let lastIndex = index(idx, offsetBy: chunkCount, limitedBy: endIndex) ?? endIndex
      result.append(self[idx ..< lastIndex])
      idx = lastIndex
    }
    return result
  }
}

values.chunks(ofCount: 3)
Array(FizzBuzz().chunks(ofCount: 5).last!)
"Hello world".chunks(ofCount: 2)
