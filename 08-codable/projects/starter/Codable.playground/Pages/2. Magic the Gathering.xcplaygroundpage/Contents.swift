//: [Previous](@previous)

import UIKit

let data = API.getData(for: .magicTheGathering)

let decoder = JSONDecoder()
do {
  let cards = try decoder.decode([Card].self, from: data)
  for card in cards {
    print("🃏 \(card.name) #\(card.number)")
  }
} catch {
  print("Something went wrong: \(error)")
}

struct Card: Decodable {
  let id: String
  let name: String
  let type: String
  let text: String
  let number: String
  let flavor: String?
  let imageUrl: URL?
}

//: [Next](@next)
