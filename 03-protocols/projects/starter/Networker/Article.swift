/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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
