/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

protocol NetworkingDelegate: AnyObject {
  func headers(for networking: Networking) -> [String: String]
  func networking(_ networking: Networking, didReceive response: URLResponse)
}

extension NetworkingDelegate {
  func headers(for networking: Networking) -> [String: String] {
    [:]
  }
  func networking(_ networking: Networking, didReceive response: URLResponse) {

  }
}

protocol Networking {
  func fetch(_ request: Request) async throws -> Data
  var delegate: NetworkingDelegate? { get set }
}

class Networker: Networking {
  weak var delegate: NetworkingDelegate?
  
  func fetch(_ request: Request) async throws -> Data {
    var urlRequest = URLRequest(url: request.url)
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.allHTTPHeaderFields = delegate?.headers(for: self)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    delegate?.networking(self, didReceive: response)
    return data
  }
}
