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
//: [Next](@next)
