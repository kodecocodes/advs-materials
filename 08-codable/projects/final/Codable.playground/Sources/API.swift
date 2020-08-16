import Foundation

public enum API {}
public extension API {
  static func getData(for api: Kind) -> Data {
    guard let path = Bundle.main.path(forResource: api.file, ofType: nil),
          let data = FileManager.default.contents(atPath: path) else {
      fatalError("Can't locate API data, something is wrong")
    }

    return data
  }
}

public extension API {
  enum Kind {
    case magicTheGathering
    case alphaVantage(interval: AlphaVantageInterval)
    case rwBooks
    case rwBooksKebab

    var file: String {
      switch self {
      case .magicTheGathering:
        // Fetched from https://api.magicthegathering.io/v1/cards
        return "magic.json"
      case .alphaVantage(let interval):
        // Fetched from https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=JPM&interval=1min
        return "av_\(interval.rawValue)min.json"
      case .rwBooks:
        return "books.json"
      case .rwBooksKebab:
        return "booksKebab.json"
      }
    }
  }
}

public extension API {
  enum AlphaVantageInterval: Int {
    case oneMinute = 1
    case fiveMinutes = 5
    case fifteenMinutes = 15
    case thirtyMinutes = 30
  }
}
