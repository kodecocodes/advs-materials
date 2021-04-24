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
    
    var address = customer.nestedContainer(
      keyedBy: AddressKeys.self,
      forKey: .address
    )
    try address.encode(street, forKey: .street)
    try address.encode(city, forKey: .city)
    try address.encode(zip, forKey: .zip)

    var contactInfo = customer.nestedContainer(
      keyedBy: ContactInfoKeys.self,
      forKey: .contactInfo
    )
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

/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

