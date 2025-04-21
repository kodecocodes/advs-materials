/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

// 1. Turn the array, `["a", "tale", "of", "two", "cities"]` into a type-erased sequence.

let words = AnySequence(["a", "tale", "of", "two", "cities"])

print(type(of: words))
for word in words {
  print(word)
}

// 2. Write an extension on `Sequence` called `countingDown()` that returns an array of tuples of remaining count and elements. The array from question one returns: `[(4, "cities"), (3, "two"), (2, "of"), (1, "tale"), (0, "a")]`  Hint: sequence algorithms enumerated() and reversed() might help you get the job done.

extension Sequence {
  func countingDown() -> [(Int, Element)] {
    enumerated().reversed().map { ($0.offset, $0.element) }
  }
}
print(words.countingDown())

// 3. Create a method `primes(to value: Int) -> AnySequence<Int>` that creates a sequence of prime numbers upto but not including `value`.  Brute force prime finding is fine. For example, `primes(through: 32)` will return `[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]`.

func primes(through value: Int) -> AnySequence<Int> {
  AnySequence(
    sequence(state: 2) { current in
      // check if we are already exhausted
      guard current <= value else {
        return nil
      }
      // compute the next prime
      defer {
        func isPrime(_ value: Int) -> Bool {
          let greatestPossibleFactor = Int(Double(value).squareRoot().rounded(.awayFromZero))
          for factor in 2...greatestPossibleFactor {
            if value.isMultiple(of: factor) {
              return false
            }
          }
          return true
        }
        repeat {
          current += 1
        } while !isPrime(current) && current <= value
      }
      // return the current prime
      return current
    }
  )
}

print(Array(primes(through: 100)))

