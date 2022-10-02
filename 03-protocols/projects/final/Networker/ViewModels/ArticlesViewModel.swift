/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI
import Combine

class ArticlesViewModel: ObservableObject {
  @Published private(set) var articles: [Article] = []

  private var networker: Networking

  init(networker: Networking) {
    self.networker = networker
    self.networker.delegate = self
  }

  private var cancellables: Set<AnyCancellable> = []

  @Sendable @MainActor
  func fetchArticles() async {
    do {
      let request = ArticleRequest()
      let data = try await networker.fetch(request)
      articles = try [Article](from: data)
    } catch {
      articles = []
    }
  }

  @Sendable @MainActor
  func fetchImage(for article: Article) async {
    guard article.downloadedImage == nil,
      let articleIndex = articles.firstIndex(where: { $0.id == article.id })
    else {
      return
    }

    let request = ImageRequest(url: article.image)
    guard let data = try? await networker.fetch(request) else {
      return
    }
    articles[articleIndex].downloadedImage = UIImage(data: data)
  }
}

extension ArticlesViewModel: NetworkingDelegate {
  func headers(for networking: Networking) -> [String: String] {
    return ["Content-Type": "application/vnd.api+json; charset=utf-8"]
  }

  func networking(_ networking: Networking, didReceive response: URLResponse) {
    print("Received response:")
    print(response)
  }
}
