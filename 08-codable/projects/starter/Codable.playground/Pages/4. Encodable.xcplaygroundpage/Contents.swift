//: [Previous](@previous)

import CryptoKit
import Foundation

struct Customer: Encodable {
  var name: String
  var accessKey: String
  var atmCode: String
  var street: String
  var city: String
  var zip: Int
  var homePhone: String
  var cellularPhone: String
  var email: String
  let website: String
  let addedOn = Date()
}

let customer = Customer(
  name: "Shai Mishali",
  accessKey: "S|_|p3rs3cr37",
  atmCode: "1132",
  street: "3828 Piermont Drive",
  city: "Albuquerque",
  zip: 87112,
  homePhone: "+1 212-741-4695",
  cellularPhone: "+972 542-288-482",
  email: "freak4pc@gmail.com",
  website: "http://github.com/freak4pc"
)

do {
  let encoder = JSONEncoder()

  let data = try encoder.encode(customer)
  print(String(data: data, encoding: .utf8) ?? "")
} catch {
  print("Something went wrong: \(error)")
}

//: [Next](@next)

/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

