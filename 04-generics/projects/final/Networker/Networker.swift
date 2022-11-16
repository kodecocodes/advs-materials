/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2022 Kodeco LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift
import Foundation

class Networker {
  func fetch<T: Decodable>(url: URL) async throws -> T {
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    let decoded = try decoder.decode(T.self, from: data)
    return decoded
  }

  func upload(_ value: some Encodable, to url: URL) async throws -> URLResponse {
    let encoder = JSONEncoder()
    let json = try encoder.encode(value)
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = json
    let (_, response) = try await URLSession.shared.data(for: request)
    return response
  }

  func fetch<R: Request>(_ request: R) async throws -> R.Output {
    var urlRequest = URLRequest(url: request.url)
    urlRequest.httpMethod = request.method.rawValue
    let (data, _) = try await URLSession.shared
      .data(for: urlRequest)
    let decoded = try request.decode(data)
    return decoded
  }

  func download(_ request: some Request<Data>) async throws -> URL {
    var urlRequest = URLRequest(url: request.url)
    urlRequest.httpMethod = request.method.rawValue
    let (url, _) = try await URLSession.shared
      .download(for: urlRequest)
    return url
  }

  func fetchAll<Output>(_ requests: [any Request<Output>]) async throws -> [Output] {
    var outputs: [Output] = []
    for request in requests {
      outputs.append(try await fetch(request))
    }
    return outputs
  }
}
