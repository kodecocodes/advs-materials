/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift


import Foundation

/// Represents a raw Coding Key, to be used when
/// `Codable` keys are dynamic and aren't known in advanced
public struct AnyCodingKey: CodingKey {
  public let stringValue: String
  public let intValue: Int?

  public init?(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = nil
  }

  public init?(intValue: Int) {
    self.intValue = intValue
    self.stringValue = "\(intValue)"
  }
}
