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

import SwiftUI
import Combine

class ArticlesViewModel: ObservableObject {
  private var networker: Networking
  @Published private(set) var articles: [Article] = []
  private var cancellables: Set<AnyCancellable> = []

  init(networker: Networking) {
    self.networker = networker
    self.networker.delegate = self
  }

  func fetchArticles() {
    let request = ArticleRequest()
    networker.fetch(request)
      .tryMap([Article].init)
      .replaceError(with: [])
      .assign(to: \.articles, on: self)
      .store(in: &cancellables)
  }

  func fetchImage(for article: Article) {
    guard article.downloadedImage == nil,
      let articleIndex = articles.firstIndex(where: { $0.id == article.id })
    else {
      print("Already downloaded")
      return
    }

    let request = ImageRequest(url: article.image)
    networker.fetch(request)
      .map(UIImage.init)
      .replaceError(with: nil)
      .sink { [weak self] image in
        self?.articles[articleIndex].downloadedImage = image
      }
      .store(in: &cancellables)
  }
}

extension ArticlesViewModel: NetworkingDelegate {
  func headers(for networking: Networking) -> [String: String] {
    return ["Content-Type": "application/vnd.api+json; charset=utf-8"]
  }

  func networking(_ networking: Networking, transformPublisher publisher: AnyPublisher<Data, URLError>) -> AnyPublisher<Data, URLError> {
    publisher.receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
}
