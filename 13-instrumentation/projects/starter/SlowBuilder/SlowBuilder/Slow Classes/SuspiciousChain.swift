/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

struct SuspiciousStruct {
  var name: String = ""
  var phone: String = ""
  var email: String = ""
  var country: String = ""
  var city: String = ""
  var address: String = ""
  var job: String = ""

  func setting<T>(
    _ keyPath: WritableKeyPath<Self, T>,
    value: () -> T
  ) -> Self {
    var copy = self
    copy[keyPath: keyPath] = value()
    return copy
  }

  static func getSuspiciousStruct() -> Self {
    SuspiciousStruct()
      .setting(\.name) { "SomeName" }
      .setting(\.phone) { "0123456789" }
      .setting(\.email) { "email@somewhere.com" }
      .setting(\.country) { "Earth-Country" }
      .setting(\.city) { "Earth-Country-City" }
      .setting(\.address) { "A place on earth, beside that shop" }
      .setting(\.job) { "Super-Duper iOS Developer" }
  }
}
