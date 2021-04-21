/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

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
