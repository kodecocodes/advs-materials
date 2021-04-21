/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

struct Guitar: CustomStringConvertible {
  static var basePrice: Decimal = 2_000
  let shape: Shape
  let color: Color
  let body: Body
  let fretboard: Fretboard

  var price: Decimal {
    Self.basePrice + additionsPrice
  }

  var additionsPrice: Decimal {
    [shape.price,
     color.price,
     body.price,
     fretboard.price].reduce(0, +)
  }

  var description: String {
    "\(color.name) \(shape.name) with \(body.name) body and \(fretboard.name) fretboard"
  }
}

// MARK: - Guitar Additions
extension Guitar {
  enum Shape: String, Addition {
    static var type: String { "Shape" }

    case casual
    case chunky
    case longV
    case sharpV

    var name: String {
      switch self {
      case .longV:
        return "Long V"
      case .sharpV:
        return "Sharp V"
      default:
        return rawValue.capitalized
      }
    }

    var price: Decimal {
      switch self {
      case .chunky, .casual: return 0
      case .longV: return 75
      case .sharpV: return 100
      }
    }
  }

  enum Color: String, Addition {
    static var type: String { return "Color" }

    case natural
    case sky
    case dusk
    case earth

    var name: String {
      rawValue.capitalized
    }

    var price: Decimal {
      switch self {
      case .natural, .dusk:
        return 0
      case .earth:
        return 50
      case .sky:
        return 150
      }
    }
  }

  enum Body: String, Addition {
    static var type: String { "Body" }

    case mahogany
    case blackLimba
    case swampAsh
    case koa

    var name: String {
      switch self {
      case .blackLimba:
        return "Black Limba"
      case .swampAsh:
        return "Swamp Ash"
      default:
        return rawValue.capitalized
      }
    }

    var price: Decimal {
      switch self {
      case .mahogany:
        return 0
      case .blackLimba:
        return 150
      case .swampAsh:
        return 80
      case .koa:
        return 100
      }
    }
  }

  enum Fretboard: String, Addition {
    static var type: String { "Fretboard" }

    case rosewood
    case birdseyeMaple
    case ebony
    case blackLimba

    var name: String {
      switch self {
      case .birdseyeMaple:
        return "Birdseye Maple"
      case .ebony:
        return "Ebony"
      case .blackLimba:
        return "Black Limba"
      default:
        return rawValue.capitalized
      }
    }

    var price: Decimal {
      switch self {
      case .rosewood:
        return 0
      case .birdseyeMaple:
        return 80
      case .ebony:
        return 100
      case .blackLimba:
        return 120
      }
    }
  }
}
