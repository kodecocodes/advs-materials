/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

protocol Request: Sendable {
  var url: URL { get }
  var method: HTTPMethod { get }
}

struct ArticleRequest: Request {
  var url: URL {
    let baseURL = "https://api.kodeco.com/api"
    let path = "/contents?filter[content_types][]=article"
    return URL(string: baseURL + path)!
  }

  var method: HTTPMethod { .get }
}

struct ImageRequest: Request {
  let url: URL
  var method: HTTPMethod { .get }
}
