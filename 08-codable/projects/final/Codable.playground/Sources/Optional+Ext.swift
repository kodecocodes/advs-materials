/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift


import Foundation

public extension Optional {
  func unwrapOrThrow() throws -> Wrapped {
    guard let unwrapped = self else {
      throw Error.unexpectedNil(type: Wrapped.self)
    }

    return unwrapped
  }

  enum Error: Swift.Error {
    case unexpectedNil(type: Wrapped.Type)
  }
}
