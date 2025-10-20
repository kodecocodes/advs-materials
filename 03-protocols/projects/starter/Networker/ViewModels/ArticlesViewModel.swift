/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2022 Kodeco LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import SwiftUI
import Combine

@MainActor
@Observable class ArticlesViewModel {
  private(set) var articles: [Article] = []

  func fetchArticles() async {
    articles = [ArticleRow_Previews.article]
  }

  func fetchImage(for article: Article) async {
  }
}
