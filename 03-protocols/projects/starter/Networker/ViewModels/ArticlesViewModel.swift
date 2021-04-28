/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI
import Combine

class ArticlesViewModel: ObservableObject {
  @Published private(set) var articles: [Article] = []

  private var cancellables: Set<AnyCancellable> = []

  func fetchArticles() {
    articles = [ArticleRow_Previews.article]
  }

  func fetchImage(for article: Article) {
  }
}
