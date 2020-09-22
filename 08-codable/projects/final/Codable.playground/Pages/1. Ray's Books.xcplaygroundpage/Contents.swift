//: [Previous](@previous)

import UIKit
import PlaygroundSupport

let data = API.getData(for: .rwBooksKebab)
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromKebabCase
decoder.dataDecodingStrategy = .base64

do {
  let books = try decoder.decode([Book].self, from: data)
  for book in books {
    print("\(book.name) (\(book.id))",
          "by \(book.authors.joined(separator: ", ")).",
          "Get it at: \(book.storeUrl)")
    _ = book.image
  }
} catch {
  print("Something went wrong: \(error)")
}

struct Book: Decodable {
  let id: String
  let name: String
  let authors: [String]
  let storeUrl: URL
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

/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
