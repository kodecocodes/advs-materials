/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation
import UIKit

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case update = "UPDATE"
  case delete = "DELETE"
}

protocol Request<Output> {
  associatedtype Output

  var url: URL { get }
  var method: HTTPMethod { get }
  func decode(_ data: Data) throws -> Output
}

struct ArticleRequest: Request {
  typealias Output = [Article]

  var url: URL {
    let baseURL = "https://api.raywenderlich.com/api"
    let path = "/contents?filter[content_types][]=article"
    return URL(string: baseURL + path)!
  }

  var method: HTTPMethod { .get }

  func decode(_ data: Data) throws -> [Article] {
    let decoder = JSONDecoder()
    let articlesCollection = try decoder
      .decode(Articles.self, from: data)
    return articlesCollection.data.map { $0.article }
  }
}

extension Request where Output: Decodable {
  func decode(_ data: Data) throws -> Output {
    let decoder = JSONDecoder()
    return try decoder.decode(Output.self, from: data)
  }
}

struct ImageRequest: Request {
  let url: URL
  var method: HTTPMethod { .get }

  func decode(_ data: Data) throws -> UIImage {
    if let image = UIImage(data: data) {
      return image
    } else {
      throw DecodingError.typeMismatch(UIImage.self, DecodingError.Context(
        codingPath: [],
        debugDescription: "No image in data."))
    }
  }
}
