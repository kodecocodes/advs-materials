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
    let url = URL(string: "https://api.raywenderlich.com/api/contents?filter[content_types][]=article")!
    do {
      let articlesData: Articles = try await networker.fetch(url: url)
      articles = articlesData.data.map { $0.article }
      let imageRequests = articles.map {
        ImageRequest(url: $0.image)
      }
      let images = try await networker.fetchAll(imageRequests)
      for i in 0..<articles.count {
        articles[i].downloadedImage = images[i]
      }
    } catch {
      articles = []
    }
    reloadSavedArticles()
  }

  func readLater(_ article: Article) {
    var savedArticles = UserDefaultsValue<[String]>(key: "savedArticles")
    savedArticles.append(article.id)
    reloadSavedArticles()
  }

  func reloadSavedArticles() {
    let storedSavedArticles = UserDefaultsValue<[String]>(key: "savedArticles")
    if let savedArticleIDs = storedSavedArticles.value {
      savedArticles = articles.filter {
        savedArticleIDs.contains($0.id)
      }
    }
  }
}
