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
    do {
      articles = try await networker.fetch(ArticleRequest())
      let imageRequests = articles
        .compactMap(\.image)
        .map(ImageRequest.init)
      let images = try await networker.fetchAll(imageRequests)
      for i in 0..<images.count {
        articles[i].downloadedImage = images[i]
      }
    } catch {
      articles = []
    }

    reloadSavedArticles()
  }

  func readLater(_ article: Article) {
    var savedArticles = UserDefaultsValue<[String]>(
      key: "savedArticles")
    savedArticles.append(article.id)
    reloadSavedArticles()
  }

  func reloadSavedArticles() {
    let storedSavedArticles = UserDefaultsValue<[String]>(
      key: "savedArticles")
    if let savedArticleIDs = storedSavedArticles.value {
      savedArticles = articles.filter {
        savedArticleIDs.contains($0.id)
      }
    }
  }
}
