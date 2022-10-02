/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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
