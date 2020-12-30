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

import Foundation
import UIKit

struct Article: Identifiable {
  let name: String
  let description: String
  let image: URL
  let id: String
  var downloadedImage: UIImage?
}

extension Article: Codable {
  enum CodingKeys: String, CodingKey {
    case name
    case description
    case image = "card_artwork_url"
    case id = "released_at"
  }
}

struct Articles: Codable {
  let data: [ArticleData]
}

struct ArticleData: Codable {
  let article: Article

  enum CodingKeys: String, CodingKey {
    case article = "attributes"
  }
}

extension Array: URLSessionDecodable where Element == Article {
  init(fromRequestOutput output: Data) throws {
    let decoder = JSONDecoder()
    let articlesCollection = try decoder.decode(Articles.self, from: output)
    let articles = articlesCollection.data.map { $0.article }
    self.init(articles)
  }
}

struct ArticleRequest: Request {
  var url: URL {
    let baseURL = "https://api.raywenderlich.com/api"
    let path = "/contents?filter[content_types][]=article"
    // swiftlint:disable:next force_unwrapping
    return URL(string: baseURL + path)!
  }

  var method: HTTPMethod { .get }
}
