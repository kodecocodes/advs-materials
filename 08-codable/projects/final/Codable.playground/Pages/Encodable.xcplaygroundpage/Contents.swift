//: [Previous](@previous)

import Foundation

struct Customer {
  var name: String
  var accessKey: String
  var atmCode: String
  var street: String
  var city: String
  var zip: Int
  var homePhone: String
  var cellularPhone: String
  var email: String
  let addedOn = Date()

//  enum CustomerKeys: String, CodingKey {
//    case name, accessKey, atmCode, addedOn
//    case address, contactInfo
//  }
//
//
//
//  enum AddressKeys: String, CodingKey {
//    case street, city, zip
//  }
//
//  enum ContactInfoKeys: String, CodingKey {
//    case homePhone, cellularPhone, email
//  }
}

let customers = [
  Customer(name: "Shai Mishali",
           accessKey: "S|_|p3rs3cr37",
           atmCode: "1132",
           street: "3828 Piermont Drive",
           city: "Albuquerque",
           zip: 87112,
           homePhone: "+1 212-741-4695",
           cellularPhone: "+972 542-288-482",
           email: "freak4pc@gmail.com")
]

extension Customer: Encodable {
//  func encode(to encoder: Encoder) throws {
//    var customer = encoder.container(keyedBy: CustomerKeys.self)
//    try customer.encodeIfPresent(name, forKey: .name)
//    try customer.encode(accessKey, forKey: .accessKey)
//    try customer.encode(atmCode, forKey: .atmCode)
//    try customer.encode(addedOn, forKey: .addedOn)
//
//    var address = customer.nestedContainer(keyedBy: AddressKeys.self, forKey: .address)
//    try address.encode(street, forKey: .street)
//    try address.encode(city, forKey: .city)
//    try address.encode(zip, forKey: .zip)
//
//    var contactInfo = customer.nestedContainer(keyedBy: ContactInfoKeys.self, forKey: .contactInfo)
//    try contactInfo.encode(homePhone, forKey: .homePhone)
//    try contactInfo.encode(cellularPhone, forKey: .cellularPhone)
//    try contactInfo.encode(email, forKey: .email)
//  }
}

let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
encoder.keyEncodingStrategy = .convertToSnakeCase
encoder.dataEncodingStrategy = .base64
encoder.dateEncodingStrategy = .iso8601

let data = try! encoder.encode(customers)
print(String(data: data, encoding: .utf8) ?? "")

struct EncryptedCodableString: ExpressibleByStringLiteral, Codable {
    let value: String

    init(stringLiteral value: StringLiteralType) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self).decrypted()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value.encrypted())
    }
}

//: [Next](@next)
