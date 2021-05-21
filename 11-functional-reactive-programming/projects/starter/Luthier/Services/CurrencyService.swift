/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation
import Combine

final class CurrencyService {
  func getExchangeRate(for currency: Currency) -> AnyPublisher<Decimal, Error> {
    Empty().eraseToAnyPublisher()
  }
}

private struct ExchangeResponse: Decodable {
  let rates: [String: Decimal]
  let base: String
}
