/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

struct UserDefaultsValue<Stored> {
  let key: String

  var value: Stored? {
    get {
      UserDefaults.standard.value(forKey: key) as? Stored
    } set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }

  mutating func append<Element>(_ element: Element) where Stored == Array<Element> {
    if let value {
      self.value = value + [element]
    } else {
      self.value = [element]
    }
  }
}
