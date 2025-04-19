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
