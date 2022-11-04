/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2022 Kodeco LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import SwiftUI

struct ArticlesView: View {
  @StateObject private var viewModel = ArticlesViewModel()

  var body: some View {
    List(viewModel.articles) { article in
      ArticleRow(article: article, image: .constant(nil))
        .task { await viewModel.fetchImage(for: article) }
    }
    .task(viewModel.fetchArticles)
  }
}

struct ArticlesView_Previews: PreviewProvider {
  static var previews: some View {
    ArticlesView()
  }
}
