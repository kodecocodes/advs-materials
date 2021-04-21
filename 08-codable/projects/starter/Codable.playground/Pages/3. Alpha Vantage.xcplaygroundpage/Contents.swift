//: [Previous](@previous)

import Foundation
import PlaygroundSupport

func getStock(interval: API.AlphaVantageInterval) throws -> Stock {
  let data = API.getData(for: .alphaVantage(interval: interval))
  let decoder = JSONDecoder()

  return try decoder.decode(Stock.self, from: data)
}

struct Stock: Decodable {

}

do {
  let stock = try getStock(interval: .oneMinute)
  print(stock)
} catch {
  print("Something went wrong: \(error)")
}

//: [Next](@next)

/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

