/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
import Combine
@testable import Networker

class MockNetworker: Networking {
  weak var delegate: NetworkingDelegate?

  func fetch(_ request: Request) -> AnyPublisher<Data, URLError> {
    let outputData: Data

    switch request {
    case is ArticleRequest:
      let article = Article(
        name: "Article Name",
        description: "Article Description",
        // swiftlint:disable:next force_unwrapping
        image: URL(string: "https://image.com")!,
        id: "Article ID",
        downloadedImage: nil)
      let articleData = ArticleData(article: article)
      let articles = Articles(data: [articleData])
      // swiftlint:disable:next force_try
      outputData = try! JSONEncoder().encode(articles)
    default:
      outputData = Data()
    }

    return Just<Data>(outputData)
      .setFailureType(to: URLError.self)
      .eraseToAnyPublisher()
  }
}

class ArticlesViewModelTests: XCTestCase {
  // swiftlint:disable:next implicitly_unwrapped_optional
  var viewModel: ArticlesViewModel!
  var cancellables: Set<AnyCancellable> = []

  override func setUpWithError() throws {
    try super.setUpWithError()
    viewModel = ArticlesViewModel(networker: MockNetworker())
  }

  func testArticlesAreFetchedCorrectly() {
    XCTAssert(viewModel.articles.isEmpty)
    let expectation = XCTestExpectation(description: "Article received")

    viewModel.$articles.sink { articles in
      guard !articles.isEmpty else {
        return
      }
      XCTAssertEqual(articles[0].id, "Article ID")
      expectation.fulfill()
    }
    .store(in: &cancellables)

    viewModel.fetchArticles()
    wait(for: [expectation], timeout: 0.1)
  }
}
