/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation
import Combine
import UIKit

protocol NetworkingDelegate: AnyObject {
  func headers(for networking: Networking) -> [String: String]

  func networking(
    _ networking: Networking,
    transformPublisher: AnyPublisher<Data, URLError>
  ) -> AnyPublisher<Data, URLError>
}

extension NetworkingDelegate {
  func headers(for networking: Networking) -> [String: String] {
    [:]
  }

  func networking(
    _ networking: Networking,
    transformPublisher publisher: AnyPublisher<Data, URLError>
  ) -> AnyPublisher<Data, URLError> {
    publisher
  }
}

protocol Networking {
  var delegate: NetworkingDelegate? { get set }
  func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, Error>
  func fetch<R: Request>(_ request: R) -> AnyPublisher<R.Output, Error>
  func fetchWithCache<R: Request>(_ request: R) -> AnyPublisher<R.Output, Error> where R.Output == UIImage
}

class Networker: Networking {
  weak var delegate: NetworkingDelegate?
  private let imageCache = RequestCache<UIImage>()

  func fetchWithCache<R: Request>(_ request: R) -> AnyPublisher<R.Output, Error> where R.Output == UIImage {
    if let response = imageCache.response(for: request) {
      return Just<R.Output>(response)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    // swiftlint:disable:next trailing_closure
    return fetch(request)
      .handleEvents(receiveOutput: {
        self.imageCache.saveResponse($0, for: request)
      })
      .eraseToAnyPublisher()
  }

  func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func fetch<R: Request>(_ request: R) -> AnyPublisher<R.Output, Error> {
    var urlRequest = URLRequest(url: request.url)
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.allHTTPHeaderFields = delegate?.headers(for: self)

    var publisher = URLSession.shared
      .dataTaskPublisher(for: urlRequest)
      .compactMap { $0.data }
      .eraseToAnyPublisher()

    if let delegate = delegate {
      publisher = delegate.networking(self, transformPublisher: publisher)
    }

    return publisher.tryMap(request.decode).eraseToAnyPublisher()
  }
}
