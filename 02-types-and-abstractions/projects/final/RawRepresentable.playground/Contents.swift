/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2023 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

enum Coin: Int, CaseIterable {
  case penny = 1, nickel = 5, dime = 10, quarter = 25
}

let lucky = Coin(rawValue: 1)
lucky?.rawValue

struct Email: RawRepresentable {
  var rawValue: String

  init?(rawValue: String) {
    guard rawValue.contains("@") else {
      return nil
    }
    self.rawValue = rawValue
  }
}

func send(message: String, to: Email) {

}


