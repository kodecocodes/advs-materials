/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case update = "UPDATE"
  case delete = "DELETE"
}

protocol Request {
  var url: URL { get }
  var method: HTTPMethod { get }
  associatedtype Output
  func decode(_ data: Data) throws -> Output
}

extension Request where Output: Decodable {
  func decode(_ data: Data) throws -> Output {
    let decoder = JSONDecoder()
    return try decoder.decode(Output.self, from: data)
  }
}

struct AnyRequest: Hashable {
  let url: URL
  let method: HTTPMethod
}
