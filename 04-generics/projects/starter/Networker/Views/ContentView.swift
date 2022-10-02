/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

struct ContentView: View {
  @ObservedObject private var viewModel = ArticlesViewModel(networker: Networker())

  var body: some View {
    TabView {
      ArticlesView(articles: viewModel.articles, readLaterAction: viewModel.readLater)
        .tabItem {
          Label("All Articles", systemImage: "list.bullet")
        }
      ArticlesView(articles: viewModel.savedArticles)
        .tabItem {
          Label("Read Later", systemImage: "checklist")
        }
    }.task(viewModel.fetchArticles)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
