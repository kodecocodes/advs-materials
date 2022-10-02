/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import XCTest
import Combine
@testable import Networker

class MockNetworker: Networking {
  weak var delegate: NetworkingDelegate?
  
  func fetch(_ request: Request) async throws -> Data {
    switch request {
    case is ArticleRequest:
      let article = Article(
        name: "Article Name",
        description: "Article Description",
        image: URL(string: "https://image.com")!,
        id: "Article ID",
        downloadedImage: nil)
      let articleData = ArticleData(article: article)
      let articles = Articles(data: [articleData])
      return try! JSONEncoder().encode(articles)
    default:
      return Data()
    }
  }
}

class ArticlesViewModelTests: XCTestCase {
  // swiftlint:disable:next implicitly_unwrapped_optional
  var viewModel: ArticlesViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()
    viewModel = ArticlesViewModel(networker: MockNetworker())
  }

  func testArticlesAreFetchedCorrectly() async {
    XCTAssert(viewModel.articles.isEmpty)
    await viewModel.fetchArticles()
    XCTAssertEqual(viewModel.articles[0].id, "Article ID")
  }
}
