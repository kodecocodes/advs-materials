/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

extension Decimal {
  var formatted: String { formatted(for: .usd) }

  func formatted(for currency: Currency) -> String {
    let nf = NumberFormatter()
    nf.numberStyle = .currency
    nf.currencyCode = currency.code
    nf.maximumFractionDigits = 0
    return nf.string(for: self) ?? String(describing: self)
  }
}
