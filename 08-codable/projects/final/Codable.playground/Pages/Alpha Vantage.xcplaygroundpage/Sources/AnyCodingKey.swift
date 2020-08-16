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
