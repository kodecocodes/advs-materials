//: [Previous](@previous)

import UIKit

let data = API.getData(for: .magicTheGathering)

let decoder = JSONDecoder()
do {
  let cards = try decoder.decode([Card].self, from: data)
  for card in cards {
    print(
      "🃏 \(card.name) #\(card.number) is a \(card.rarity) \(card.type)",
      "and needs \(card.mana) mana (cost is \(card.mana.cost)).",
      "It's part of \(card.set.name) (\(card.set.id)).",
      card.attributes.map { "It's attributed as \($0.power)/\($0.toughness)." } ?? ""
    )
    
    // Uncomment to show rulings
    // print("Rulings: \(card.rulings.joined(separator: ", "))")

    // Uncomment to synchronously load images
    // card.image.map { UIImage(data: try! Data(contentsOf: $0)) }
  }
} catch {
  print("Something went wrong: \(error)")
}

struct Card: Decodable {
  let id: String
  let name: String
  let mana: Mana
  let type: String
  let types: [Kind]
  let rarity: Rarity
  let text: String
  let flavor: String?
  let number: String
  let image: URL?
  let rulings: [String]
  let set: Set
  let attributes: Attributes?

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.mana = try container.decodeIfPresent(Mana.self, forKey: .manaCost) ?? Mana(colors: [])
    self.type = try container.decode(String.self, forKey: .type)
    self.types = try container.decode([Kind].self, forKey: .types)
    self.rarity = try container.decode(Rarity.self, forKey: .rarity)
    self.text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
    self.flavor = try container.decodeIfPresent(String.self, forKey: .flavor)
    self.number = try container.decode(String.self, forKey: .number)
    self.image = try container.decodeIfPresent(URL.self, forKey: .imageUrl)

    // Rulings
    let rulingDict = try container.decode([[String: String]].self, forKey: .rulings)
    self.rulings = rulingDict.compactMap { $0["text"] }

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
  }

  enum CodingKeys: String, CodingKey {
    case id, name, manaCost, type, types, rarity, text, flavor, number, rulings, releaseDate, imageUrl, set, setName, power, toughness
  }
}

extension Card {
  struct Mana: Decodable, CustomStringConvertible {
    init(colors: [Color]) {
      self.colors = colors
    }

    let colors: [Color]
    var cost: Int {
      colors.reduce(into: 0) { cost, color in
        if case .colorless(let count) = color {
          cost += count
        } else {
          cost += 1
        }
      }
    }

    var description: String { colors.map(\.symbol).joined() }

    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()

      let cost = try container.decode(String.self)
      self.colors = try cost
        .components(separatedBy: "}")
        .compactMap { rawCost in
          let symbol = String(rawCost.dropFirst())
          guard !symbol.isEmpty else { return nil }

          guard let color = Color(manaCost: symbol) else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Unknown mana symbol \(symbol), \(rawCost), \(cost)")
          }

          return color
        }
    }
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

extension Card.Mana {
  enum Color {
    case colorless(Int)
    case extra
    case white
    case blue
    case black
    case red
    case green

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

    init?(manaCost: String) {
      if let value = Int(manaCost) {
        self = .colorless(value)
        return
      }

      switch manaCost.lowercased() {
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
        print("UNKNOWN \(manaCost)")
        return nil
      }
    }
  }
}

extension Card {
  enum Kind: String, Decodable {
    case artifact
    case autobot
    case character
    case conspiracy
    case creature
    case elemental
    case enchantment
    case hero
    case instant
    case land
    case phenomenon
    case plane
    case planeswalker
    case scheme
    case sorcery
    case specter
    case summon
    case tribal
    case vanguard
    case wold
    case unknown

    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let rawValue = try container.decode(String.self)
      self = Kind(rawValue: rawValue.lowercased()) ?? .unknown
    }
  }
}

//: [Next](@next)
