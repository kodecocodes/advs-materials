//: [Previous](@previous)

import CryptoKit
import Foundation

struct Customer: Encodable {
  var name: String
  var accessKey: EncryptedCodableString
  var atmCode: EncryptedCodableString
  var street: String
  var city: String
  var zip: Int
  var homePhone: String
  var cellularPhone: String
  var email: String
  let website: String
  let addedOn = Date()

  func encode(to encoder: Encoder) throws {
    var customer = encoder.container(keyedBy: CustomerKeys.self)
    try customer.encode(name, forKey: .name)
    try customer.encode(accessKey, forKey: .accessKey)
    try customer.encode(atmCode, forKey: .atmCode)
    try customer.encode(addedOn, forKey: .addedOn)

    var address = customer
      .nestedContainer(keyedBy: AddressKeys.self, forKey: .address)
    try address.encode(street, forKey: .street)
    try address.encode(city, forKey: .city)
    try address.encode(zip, forKey: .zip)

    var contactInfo = customer.nestedContainer(
      keyedBy: ContactInfoKeys.self, forKey: .contactInfo)
    try contactInfo.encode(homePhone, forKey: .homePhone)
    try contactInfo.encode(cellularPhone, forKey: .cellularPhone)
    try contactInfo.encode(email, forKey: .email)
  }

  enum CustomerKeys: String, CodingKey {
    case name, accessKey, atmCode, addedOn, address, contactInfo
  }

  enum AddressKeys: String, CodingKey {
    case street, city, zip
  }

  enum ContactInfoKeys: String, CodingKey {
    case homePhone, cellularPhone, email
  }
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
  encoder.outputFormatting = [.prettyPrinted,
                              .sortedKeys,
                              .withoutEscapingSlashes]
  encoder.keyEncodingStrategy = .convertToSnakeCase
  encoder.dateEncodingStrategy = .iso8601

  let data = try encoder.encode(customer)
  print(String(data: data, encoding: .utf8) ?? "")
} catch {
  print("Something went wrong: \(error)")
}

struct EncryptedCodableString: ExpressibleByStringLiteral,
                               Codable {
  let value: String

  // 1
  let key = SymmetricKey(data:
                         "Advanced Swift !".data(using: .utf8)!)

  // 2
  init(stringLiteral value: StringLiteralType) {
    self.value = value
  }

  // 3
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let combined = try container.decode(Data.self)
    let result = try AES.GCM.open(.init(combined: combined),
                                  using: key)
    self.value = String(data: result, encoding: .utf8) ?? ""
  }

  // 4
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    let data = value.data(using: .utf8)!
    let sealed = try AES.GCM.seal(data, using: key)
    try container.encode(sealed.combined)
  }
}

//: [Next](@next)

/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
