/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import SwiftUI

struct UserDefaultsValue<Stored> {
  let key: String

  var value: Stored? {
    get {
      UserDefaults.standard.value(forKey: key) as? Stored
    } set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }

  mutating func append<Element>(
    _ element: Element
  ) where Stored == Array<Element> {
    if let value {
      self.value = value + [element]
    } else {
      self.value = [element]
    }
  }
}
