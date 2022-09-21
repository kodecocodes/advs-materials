/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

class MockExchangeService: URLProtocol {
  private static let mockAPI = "https://api.raywenderlich.com/exchangerates"
  
  override class func canInit(with request: URLRequest) -> Bool {
    request.url?.absoluteString == Self.mockAPI
  }

  override func startLoading() {
    guard request.url?.absoluteString == Self.mockAPI else { return }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
      guard let self = self else { return }
      let data = Data("""
      {
          "base": "USD",
          "rates": {
              "EUR": 0.83,
              "ILS": 3.25,
              "GBP": 0.71
          }
      }
      """.utf8)
      
      self.client?.urlProtocol(
        self,
        didReceive: URLResponse(url: self.request.url!,
                                mimeType: nil,
                                expectedContentLength: data.count, textEncodingName: nil),
        cacheStoragePolicy: .notAllowed
      )
      
      self.client?.urlProtocol(self, didLoad: data)
      self.client?.urlProtocolDidFinishLoading(self)
    }
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }
  
  override func stopLoading() {}
}
