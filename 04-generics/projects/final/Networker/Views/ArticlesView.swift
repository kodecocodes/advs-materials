/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import SwiftUI

struct ArticlesView: View {
  let articles: [Article]
  let readLaterAction: ((Article) -> ())?

  init(articles: [Article], readLaterAction: ((Article) -> ())? = nil) {
    self.articles = articles
    self.readLaterAction = readLaterAction
  }

  var body: some View {
    List(articles) { article in
      ArticleRow(article: article, image: .constant(nil))
        .swipeActions {
          if let readLaterAction {
            Button("Read Later") {
              readLaterAction(article)
            }
          }
        }
    }
  }
}

struct ArticlesView_Previews: PreviewProvider {
  static var previews: some View {
    ArticlesView(articles: [])
  }
}
