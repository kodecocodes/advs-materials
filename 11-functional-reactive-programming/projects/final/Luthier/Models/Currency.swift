/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import Foundation

public enum Currency: String, Codable, CaseIterable, Identifiable {
  case usd
  case eur
  case gbp
  case ils

  var symbol: String {
    switch self {
    case .usd: return "$"
    case .eur: return "€"
    case .gbp: return "£"
    case .ils: return "₪"
    }
  }

  var code: String { rawValue.uppercased() }
  public var id: String { rawValue }
}
