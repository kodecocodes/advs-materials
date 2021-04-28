/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation
import Combine

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
  func fetch(_ request: Request) -> AnyPublisher<Data, URLError>
}

class Networker: Networking {
  weak var delegate: NetworkingDelegate?

  func fetch(_ request: Request) -> AnyPublisher<Data, URLError> {
    var urlRequest = URLRequest(url: request.url)
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.allHTTPHeaderFields = delegate?.headers(for: self)

    let publisher = URLSession.shared
      .dataTaskPublisher(for: urlRequest)
      .compactMap { $0.data }
      .eraseToAnyPublisher()

    if let delegate = delegate {
      return delegate.networking(self, transformPublisher: publisher)
    } else {
      return publisher
    }
  }
}
