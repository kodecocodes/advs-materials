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
  let stock = try getStock(interval: .fifteenMinutes)
  print(stock)
} catch {
  print("Something went wrong: \(error)")
}

//: [Next](@next)
