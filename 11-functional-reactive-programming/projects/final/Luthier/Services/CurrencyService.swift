/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation
import Combine

final class CurrencyService {
  func getExchangeRate(for currency: Currency) -> AnyPublisher<Decimal, Error> {
    URLSession.shared
      .dataTaskPublisher(
        for: URL(string: "https://api.exchangeratesapi.io/latest?base=USD")!
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
