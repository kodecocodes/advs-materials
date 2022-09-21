//: [Previous](@previous)

import UIKit

let data = API.getData(for: .magicTheGathering)

let decoder = JSONDecoder()
do {
  let cards = try decoder.decode([Card].self, from: data)
  for card in cards {
    print(
      "🃏 \(card.name) #\(card.number) is a \(card.rarity)",
      "\(card.type) and needs \(card.manaCost).",
      "It's part of \(card.set.name) (\(card.set.id)).",
      card.attributes.map { "It's attributed as \($0.power)/\($0.toughness)." } ?? ""
    )
    print("Rulings: \(card.rulings.joined(separator: ", "))")
  }
} catch {
  print("Something went wrong: \(error)")
}

struct Card: Decodable {
  let id: UUID
  let name: String
  let type: String
  let text: String
  let number: String
  let flavor: String?
  let imageUrl: URL?
  let manaCost: Mana
  let rarity: Rarity
  let set: Set
  let attributes: Attributes?
  let rulings: [String]

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(UUID.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.manaCost = try container.decode(Mana.self, forKey: .manaCost)
    self.type = try container.decode(String.self, forKey: .type)
    self.rarity = try container.decode(Rarity.self, forKey: .rarity)
    self.text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
    self.flavor = try container.decodeIfPresent(String.self, forKey: .flavor)
    self.number = try container.decode(String.self, forKey: .number)
    self.imageUrl = try container.decodeIfPresent(URL.self, forKey: .imageUrl)

    // Set
    self.set = Set(id: try container.decode(String.self, forKey: .set),
                   name: try container.decode(String.self, forKey: .setName))

    // Attributes
    if let power = try container.decodeIfPresent(String.self, forKey: .power),
       let toughness = try container.decodeIfPresent(String.self, forKey: .toughness) {
      self.attributes = Attributes(power: power, toughness: toughness)
    } else {
      self.attributes = nil
    }

    // Rulings
    let rulingDict = try container.decode([[String: String]].self, forKey: .rulings)
    self.rulings = rulingDict.compactMap { $0["text"] }
  }

  enum CodingKeys: String, CodingKey {
    case id, name, manaCost, type, rarity
    case text, flavor, number, set, setName
    case power, toughness, rulings, imageUrl
  }
}

extension Card {
  /// Card's Mana
  struct Mana: Decodable, CustomStringConvertible {
    let colors: [Color]

    var description: String { colors.map(\.symbol).joined() }

    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let cost = try container.decode(String.self)

      self.colors = try cost
        .components(separatedBy: "}")
        .dropLast()
        .compactMap { rawCost in
          let symbol = String(rawCost.dropFirst())

          guard !symbol.isEmpty,
                let color = Color(symbol: symbol) else {
            throw DecodingError.dataCorruptedError(
              in: container,
              debugDescription: "Unknown mana symbol \(symbol)")
          }

          return color
        }
    }
  }
}

extension Card.Mana {
  /// Card's Mana Color
  enum Color {
    case colorless(Int)
    case extra
    case white
    case blue
    case black
    case red
    case green

    init?(symbol: String) {
      if let value = Int(symbol) {
        self = .colorless(value)
        return
      }

      switch symbol.lowercased() {
      case "w":
        self = .white
      case "u":
        self = .blue
      case "b":
        self = .black
      case "r":
        self = .red
      case "g":
        self = .green
      case "x":
        self = .extra
      default:
        print("UNKNOWN \(symbol)")
        return nil
      }
    }

    var symbol: String {
      switch self {
      case .white: return "W"
      case .blue: return "U"
      case .black: return "B"
      case .red: return "R"
      case .green: return "G"
      case .extra: return "X"
      case .colorless(let number): return "\(number)"
      }
    }
  }
}

extension Card {
  enum Rarity: String, CustomStringConvertible, Decodable {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case mythicRare = "Mythic Rare"
    case special = "Special"
    case land = "Basic Land"

    var description: String { rawValue }
  }
}

extension Card {
  struct Attributes {
    let power: String
    let toughness: String
  }
}

extension Card {
  struct Set {
    let id: String
    let name: String
  }
}

//: [Next](@next)

/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

