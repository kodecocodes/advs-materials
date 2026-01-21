/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import SwiftUI
import Combine

@MainActor
@Observable class ArticlesViewModel {
  let networker: Networker

  init(networker: Networker) {
    self.networker = networker
  }

  private(set) var articles: [Article] = []
  private(set) var savedArticles: [Article] = []

  func fetchArticles() async {
  }

  func readLater(_ article: Article) {
  }
}
