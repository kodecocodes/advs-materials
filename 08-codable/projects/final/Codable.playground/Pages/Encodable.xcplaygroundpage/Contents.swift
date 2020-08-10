//: [Previous](@previous)

import UIKit

struct Customer {
  var name: String
  @EncryptedCodable var accessKey: String
  @EncryptedCodable var atmCode: String
  var street: String
  var city: String
  var zip: Int
  var homePhone: String
  var cellularPhone: String
  var email: String
  var avatar: UIImage
  let addedOn = Date()

  enum CustomerKeys: String, CodingKey {
    case name, accessKey, atmCode, addedOn, avatar
    case address, contactInfo
  }

  enum AddressKeys: String, CodingKey {
    case street, city, zip
  }

  enum ContactInfoKeys: String, CodingKey {
    case homePhone, cellularPhone, email
  }
}

extension Customer: Encodable {
  func encode(to encoder: Encoder) throws {
    var customer = encoder.container(keyedBy: CustomerKeys.self)
    try customer.encodeIfPresent(name, forKey: .name)
    try customer.encode(_accessKey, forKey: .accessKey)
    try customer.encode(_atmCode, forKey: .atmCode)
    try customer.encode(addedOn, forKey: .addedOn)

    var address = customer.nestedContainer(keyedBy: AddressKeys.self, forKey: .address)
    try address.encode(street, forKey: .street)
    try address.encode(city, forKey: .city)
    try address.encode(zip, forKey: .zip)

    var contactInfo = customer.nestedContainer(keyedBy: ContactInfoKeys.self, forKey: .contactInfo)
    try contactInfo.encode(homePhone, forKey: .homePhone)
    try contactInfo.encode(cellularPhone, forKey: .cellularPhone)
    try contactInfo.encode(email, forKey: .email)
  }
}

let customers = [
  Customer(name: "Shai Mishali",
           accessKey: "S|_|p3rs3cr37",
           atmCode: "1132",
           street: "100 Bedford St Corner Grove",
           city: "New York",
           zip: 10014,
           homePhone: "+1 212-741-4695",
           cellularPhone: "",
           email: "freak4pc@gmail.com",
           avatar: UIImage(named: "shai")!)
]

let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
encoder.keyEncodingStrategy = .convertToSnakeCase
encoder.dateEncodingStrategy = .iso8601

let data = try! encoder.encode(customers)
print(String(data: data, encoding: .utf8) ?? "")

@propertyWrapper
struct EncryptedCodable: Codable {
  var wrappedValue: String

  init(wrappedValue: String) {
    self.wrappedValue = wrappedValue
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue.encrypted())
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.wrappedValue = try container.decode(String.self).decrypted()
  }
}

//: [Next](@next)
