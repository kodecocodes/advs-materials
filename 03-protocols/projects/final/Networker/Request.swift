/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

protocol Request {
  var url: URL { get }
  var method: HTTPMethod { get }
}

struct ArticleRequest: Request {
  var url: URL {
    let baseURL = "https://api.raywenderlich.com/api"
    let path = "/contents?filter[content_types][]=article"
    return URL(string: baseURL + path)!
  }

  var method: HTTPMethod { .get }
}

struct ImageRequest: Request {
  let url: URL
  var method: HTTPMethod { .get }
}
