/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import Foundation

protocol Addition: CaseIterable, RawRepresentable, Identifiable, Hashable
where RawValue == String, AllCases.Index == Int {
  static var type: String { get }
  var name: String { get }
  var price: Decimal { get }
}

extension Addition {
  var id: String { rawValue }
  var pricedName: String {
    price > 0 ? "\(name) (+$\(price))" : name
  }
}
