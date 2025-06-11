/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

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
