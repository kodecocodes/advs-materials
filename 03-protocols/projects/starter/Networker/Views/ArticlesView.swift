/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI

struct ArticlesView: View {
  @ObservedObject private var viewModel = ArticlesViewModel()

  var body: some View {
    List(viewModel.articles) { article in
      ArticleRow(article: article, image: .constant(nil))
        .onAppear { viewModel.fetchImage(for: article) }
    }
    .onAppear(perform: viewModel.fetchArticles)
  }
}

struct ArticlesView_Previews: PreviewProvider {
  static var previews: some View {
    ArticlesView()
  }
}
