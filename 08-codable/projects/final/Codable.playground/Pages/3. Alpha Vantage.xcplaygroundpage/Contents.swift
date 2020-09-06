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
    guard let time = decoder.userInfo[.timeInterval] as? Int else {
      throw DecodingError.dataCorrupted(.init(codingPath: [],
                                              debugDescription: "Missing time interval"))
    }

    let metaKey = AnyCodingKey(stringValue: "Meta Data")!
    let timesKey = AnyCodingKey(stringValue: "Time Series (\(time)min)")!

    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    let metaContainer = try container.nestedContainer(keyedBy: MetaKeys.self, forKey: metaKey)

    self.info = try metaContainer.decode(String.self, forKey: .info)
    self.symbol = try metaContainer.decode(String.self, forKey: .symbol)
    self.refreshedAt = try metaContainer.decode(Date.self, forKey: .refreshedAt)

    let timesDictionary = try container.decode([String: [String: String]].self, forKey: timesKey)
    let timeKeys = timesDictionary.keys.compactMap(AnyCodingKey.init(stringValue:))

    let timeContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: timesKey)

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
  let stock = try getStock(interval: .fifteenMinutes)
  print("\(stock.symbol), \(stock.refreshedAt):",
        "\(stock.info) with \(stock.updates.count) updates")
  for update in stock.updates {
    _ = update.open

    print("   >> \(update.date), O/C: \(update.open)/\(update.close), L/H: \(update.low)/\(update.high), V: \(update.volume)")
  }
} catch {
  print("Something went wrong: \(error)")
}

extension Stock {
  struct Update: Decodable, CustomStringConvertible {
    let open: Float
    let high: Float
    let low: Float
    let close: Float
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

      self.open = try Float(container.decode(String.self, forKey: .open)).unwrapOrThrow()
      self.high = try Float(container.decode(String.self, forKey: .high)).unwrapOrThrow()
      self.low = try Float(container.decode(String.self, forKey: .low)).unwrapOrThrow()
      self.close = try Float(container.decode(String.self, forKey: .close)).unwrapOrThrow()
      self.volume = try Int(container.decode(String.self, forKey: .volume)).unwrapOrThrow()
    }

    var description: String {
      "\(date)|o:\(open),h:\(high),l:\(low),c:\(close),v:\(volume)"
    }
  }
}

extension CodingUserInfoKey {
    static let timeInterval = CodingUserInfoKey(rawValue: "timeInterval")!
}

//: [Next](@next)

/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
