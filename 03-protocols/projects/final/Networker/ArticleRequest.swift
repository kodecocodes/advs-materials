/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

struct ArticleRequest: Request {
  var url: URL {
    let baseURL = "https://api.raywenderlich.com/api"
    let path = "/contents?filter[content_types][]=article"
    // swiftlint:disable:next force_unwrapping
    return URL(string: baseURL + path)!
  }

  var method: HTTPMethod { .get }
}
