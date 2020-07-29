//: [Previous](@previous)

import UIKit
import PlaygroundSupport

// Snake case
example(of: "Snake case") {
  let data = API.getData(for: .rwBooks)

  let decoder = JSONDecoder()
  decoder.dataDecodingStrategy = .base64
  decoder.keyDecodingStrategy = .convertFromSnakeCase

  do {
    let books = try decoder.decode([Book].self, from: data)
    for book in books {
      print("\(book.name) (\(book.id)) by \(book.authors.joined(separator: ", ")). Get it at: \(book.storeUrl)")
      _ = book.image
    }
  } catch {
    print("Something went wrong: \(error)")
  }
}

example(of: "Kebab case") {
  let data = API.getData(for: .rwBooksKebab)

  let decoder = JSONDecoder()
  decoder.dataDecodingStrategy = .base64
  decoder.keyDecodingStrategy = .convertFromKebabCase

  do {
    let books = try decoder.decode([Book].self, from: data)
    for book in books {
      print("\(book.name) (\(book.id)) by \(book.authors.joined(separator: ", ")). Get it at: \(book.storeUrl)")
      _ = book.image
    }
  } catch {
    print("Something went wrong: \(error)")
  }
}

struct Book: Decodable {
  let id: String
  let name: String
  let storeUrl: URL
  let authors: [String]
  let imageBlob: Data
  var image: UIImage? { UIImage(data: imageBlob) }
}

extension JSONDecoder.KeyDecodingStrategy {
  static var convertFromKebabCase: JSONDecoder.KeyDecodingStrategy = .custom({ keys in
    let codingKey = keys.last!
    let key = codingKey.stringValue

    guard key.contains("-") else { return codingKey }

    let words = key.components(separatedBy: "-")
    let camelCased = words[0] + words[1...].map(\.capitalized).joined()

    return AnyCodingKey(stringValue: camelCased)!
  })
}

/// Represents a raw Coding Key, to be used when
/// `Codable` keys are dynamic and aren't known in advanced
struct AnyCodingKey: CodingKey {
  let stringValue: String
  let intValue: Int?

  init?(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = nil
  }

  init?(intValue: Int) {
    self.intValue = intValue
    self.stringValue = "\(intValue)"
  }
}

//: [Next](@next)
