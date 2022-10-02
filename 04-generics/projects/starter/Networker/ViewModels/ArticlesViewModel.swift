/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI
import Combine

class ArticlesViewModel: ObservableObject {
  let networker: Networker

  init(networker: Networker) {
    self.networker = networker
  }

  @Published private(set) var articles: [Article] = []
  @Published private(set) var savedArticles: [Article] = []

  @Sendable @MainActor
  func fetchArticles() async {
  }

  func readLater(_ article: Article) {
  }
}
