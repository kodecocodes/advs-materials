//: [Previous](@previous)

import UIKit
import PlaygroundSupport

let data = API.getData(for: .rwBooksKebab)
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromKebabCase
decoder.dataDecodingStrategy = .base64

do {
  let books = try decoder.decode([Book].self, from: data)
  print("—— Example of: Books ——")
  for book in books {
    print("\(book.name) (\(book.id))",
          "by \(book.authors.joined(separator: ", ")).",
          "Get it at: \(book.storeLink)")
    _ = book.image
  }
} catch {
  print("Something went wrong: \(error)")
}

struct Book: Decodable {
  let id: String
  let name: String
  let authors: [String]
  let storeLink: URL
  let imageBlob: Data
  var image: UIImage? { UIImage(data: imageBlob) }
}

extension JSONDecoder.KeyDecodingStrategy {
  static var convertFromKebabCase: JSONDecoder.KeyDecodingStrategy = .custom({ keys in
    let codingKey = keys.last!
    let key = codingKey.stringValue

    guard key.contains("-") else { return codingKey }

    let words = key.components(separatedBy: "-")
    let camelCased = words[0] +
                     words[1...].map(\.capitalized).joined()

    return AnyCodingKey(stringValue: camelCased)!
  })
}

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

/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

