/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2022 Kodeco LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import XCTest
import Combine
@testable import Networker

@MainActor
class ArticlesViewModelTests: XCTestCase, Sendable {
  // swiftlint:disable:next implicitly_unwrapped_optional
  var viewModel: ArticlesViewModel!

  override func setUp() async throws {
    try await super.setUp()
  }

  override func tearDown() async throws {
    try await super.tearDown()
  }

  func testArticlesAreFetchedCorrectly() async {
  }
}
