//: [Previous](@previous)

import Foundation
import PlaygroundSupport

let data = API.getData(for: .alphaVantage)
let decoder = JSONDecoder()
let dateFormatter: DateFormatter = {
  let df = DateFormatter()
  df.dateFormat = "yyyy-MM-dd HH:mm:ss"
  return df
}()
decoder.dateDecodingStrategy = .formatted(dateFormatter)
decoder.userInfo = [.updateMinutesInterval: 5]

do {
  let stock = try decoder.decode(Stock.self, from: data)
  print("\(stock.symbol), \(stock.refreshedAt): \(stock.info) with \(stock.updates.count) updates")
  for update in stock.updates {
    _ = update.open

    print("   >> \(update.date), O/C: \(update.open)/\(update.close), L/H: \(update.low)/\(update.high), V: \(update.volume)")
  }
} catch {
  print("Something went wrong: \(error)")
}

extension CodingUserInfoKey {
    /// A user info key to note the minutes refresh inteerval
    static let updateMinutesInterval = CodingUserInfoKey(rawValue: "updateTimeInterval")!
}

/// Represents a raw Coding Key, to be used when
/// `Codable` keys are dynamic and aren't known in advanced
struct AnyCodingKey: CodingKey {
  let stringValue: String
  let intValue: Int?

  init?(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = nil
  }

  init?(intValue: Int) {
    self.intValue = intValue
    self.stringValue = "\(intValue)"
  }
}

struct Stock: Decodable {
  let info: String
  let symbol: String
  let updates: [Update]
  let refreshedAt: Date

  enum Error: Swift.Error {
    case missingRefreshInterval
  }

  init(from decoder: Decoder) throws {
    guard let refreshInterval = decoder.userInfo[.updateMinutesInterval] as? Int else {
        throw Error.missingRefreshInterval
    }

    // Raw string keys, since they're dynamic
    let metaKey = AnyCodingKey(stringValue: "Meta Data")!
    let timesKey = AnyCodingKey(stringValue: "Time Series (\(refreshInterval)min)")!

    // Parse meta data
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    let metaContainer = try container.nestedContainer(keyedBy: MetaKeys.self, forKey: metaKey)
    self.info = try metaContainer.decode(String.self, forKey: .info)
    self.symbol = try metaContainer.decode(String.self, forKey: .symbol)
    self.refreshedAt = try metaContainer.decode(Date.self, forKey: .refreshedAt)

    // Time Series keys are dynamic as well, we have to figure out
    // the dictionary keys first, so we start with a simply dictionary decoding
    let timesDictionary = try container.decode([String: [String: String]].self, forKey: timesKey)
    let timeKeys = timesDictionary.keys.compactMap(AnyCodingKey.init(stringValue:))

    // Once we have all the dynamic keys, we create raw `CodingKey`s from them
    // to decode the individual `Update`s
    let timeContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: timesKey)

    self.updates = try timeKeys.reduce(into: [Update]()) { updates, currentKey in
      var update = try timeContainer.decode(Update.self, forKey: currentKey)
      update.date = dateFormatter.date(from: currentKey.stringValue) ?? update.date
      updates.append(update)
    }
  }

  enum MetaKeys: String, CodingKey {
    case info = "1. Information"
    case symbol = "2. Symbol"
    case refreshedAt = "3. Last Refreshed"
  }
}

extension Stock {
  struct Update: Decodable, CustomStringConvertible {
    var date = Date.distantPast
    let open: Float
    let high: Float
    let low: Float
    let close: Float
    let volume: Float

    enum CodingKeys: String, CodingKey {
      case open = "1. open"
      case high = "2. high"
      case low = "3. low"
      case close = "4. close"
      case volume = "5. volume"
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      self.open = Float(try container.decode(String.self, forKey: .open)) ?? -1
      self.high = Float(try container.decode(String.self, forKey: .high)) ?? -1
      self.low = Float(try container.decode(String.self, forKey: .low)) ?? -1
      self.close = Float(try container.decode(String.self, forKey: .close)) ?? -1
      self.volume = Float(try container.decode(String.self, forKey: .volume)) ?? -1
    }

    var description: String {
      "\(date)|o:\(open),h:\(high),l:\(low),c:\(close),v:\(volume)"
    }
  }
}

//: [Next](@next)
