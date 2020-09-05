//: [Previous](@previous)

import Foundation
import PlaygroundSupport

let dateFormatter: DateFormatter = {
  let df = DateFormatter()
  df.dateFormat = "yyyy-MM-dd HH:mm:ss"
  return df
}()

func getStock(interval: API.AlphaVantageInterval) throws -> Stock {
  let data = API.getData(for: .alphaVantage(interval: interval))
  let decoder = JSONDecoder()
  decoder.userInfo = [.timeInterval: interval.rawValue]
  decoder.dateDecodingStrategy = .formatted(dateFormatter)

  return try decoder.decode(Stock.self, from: data)
}

struct Stock: Decodable {
  let info: String
  let symbol: String
  let refreshedAt: Date
  let updates: [Update]

  init(from decoder: Decoder) throws {
    guard let timeInterval = decoder.userInfo[.timeInterval] as? Int else {
      throw DecodingError.dataCorrupted(.init(codingPath: [],
                                        debugDescription: "Missing time interval"))
    }

    let metaKey = AnyCodingKey(stringValue: "Meta Data")!
    let timesKey = AnyCodingKey(stringValue: "Time Series (\(timeInterval)min)")!

    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    let metaContainer = try container.nestedContainer(keyedBy: MetaKeys.self,
                                                      forKey: metaKey)

    self.info = try metaContainer.decode(String.self, forKey: .info)
    self.symbol = try metaContainer.decode(String.self, forKey: .symbol)
    self.refreshedAt = try metaContainer.decode(Date.self, forKey: .refreshedAt)

    // Time Series keys are dynamic as well, we have to figure out
    // the dictionary keys first, so we start with a simply dictionary decoding
    let timesDictionary = try container.decode([String: [String: String]].self,
                                               forKey: timesKey)
    let timeKeys = timesDictionary.keys.compactMap(AnyCodingKey.init(stringValue:))

    // Once we have all the dynamic keys, we create raw `CodingKey`s from
    // them to decode the individual `Update`s
    let timeContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                      forKey: timesKey)

    self.updates = try timeKeys.reduce(into: [Update]()) { updates, currentKey in
      var update = try timeContainer.decode(Update.self, forKey: currentKey)
      update.date = dateFormatter.date(from: currentKey.stringValue) ?? update.date
      updates.append(update)
    }
    .sorted(by: { $0.date < $1.date })
  }

  enum MetaKeys: String, CodingKey {
    case info = "1. Information"
    case symbol = "2. Symbol"
    case refreshedAt = "3. Last Refreshed"
  }
}

do {
  let stock = try getStock(interval: .oneMinute)
  print("\(stock.symbol), \(stock.refreshedAt): \(stock.info) with \(stock.updates.count) updates")
  for update in stock.updates {
    _ = update.open

    print("   >> \(update.date), O/C: \(update.open)/\(update.close), L/H: \(update.low)/\(update.high), V: \(update.volume)")
  }
} catch {
  print("Something went wrong: \(error)")
}

extension Stock {
  struct Update: Decodable, CustomStringConvertible {
    let open: Decimal
    let high: Decimal
    let low: Decimal
    let close: Decimal
    let volume: Int
    var date = Date.distantPast

    enum CodingKeys: String, CodingKey {
      case open = "1. open"
      case high = "2. high"
      case low = "3. low"
      case close = "4. close"
      case volume = "5. volume"
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      
      self.open = try Decimal(string: container.decode(String.self, forKey: .open)).unwrapOrThrow()
      self.high = try Decimal(string: container.decode(String.self, forKey: .high)).unwrapOrThrow()
      self.low = try Decimal(string: container.decode(String.self, forKey: .low)).unwrapOrThrow()
      self.close = try Decimal(string: container.decode(String.self, forKey: .close)).unwrapOrThrow()
      self.volume = try Int(container.decode(String.self, forKey: .volume)).unwrapOrThrow()
    }

    var description: String {
      "\(date)|o:\(open),h:\(high),l:\(low),c:\(close),v:\(volume)"
    }
  }
}

extension CodingUserInfoKey {
    /// A user info key to note the minutes refresh inteerval
    static let timeInterval = CodingUserInfoKey(rawValue: "timeInterval")!
}

//: [Next](@next)
