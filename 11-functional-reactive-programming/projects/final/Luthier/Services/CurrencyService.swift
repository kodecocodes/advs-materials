/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import Foundation
import Combine

final class CurrencyService {
  func getExchangeRate(for currency: Currency) -> AnyPublisher<Decimal, Error> {
    URLSession.shared
      .dataTaskPublisher(
        for: URL(string: "https://api.kodeco.com/exchangerates")!
      )
      .map(\.data)
      .decode(type: ExchangeResponse.self, decoder: JSONDecoder())
      .map { response in
        guard let rate = response.rates[currency.code] else {
          fatalError()
        }
        
        return rate
      }
      .eraseToAnyPublisher()
  }
}

private struct ExchangeResponse: Decodable {
  let rates: [String: Decimal]
  let base: String
}
