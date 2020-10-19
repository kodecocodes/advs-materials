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

import Foundation

protocol Addition: CaseIterable, RawRepresentable, Identifiable, Hashable
where RawValue == String, AllCases.Index == Int {
  static var type: String { get }
  var name: String { get }
  var price: Decimal { get }
}

extension Addition {
  var id: String { rawValue }
}

struct PricedAddition<A: Addition> {
  let addition: A
  let price: Decimal
}

struct Guitar: CustomStringConvertible {
  let shape: Shape
  let color: Color
  let body: Body
  let fretboard: Fretboard

  var price: Decimal {
    [shape.price,
     color.price,
     body.price,
     fretboard.price,
     GuitarService.basePrice].reduce(0, +)
  }

  var description: String {
    "\(color.name) \(shape.name) with \(body.name) body and \(fretboard.name) fretboard"
  }
}

extension Guitar {
  enum Shape: String, Addition {
    static var type: String { "Shape" }

    case chunky
    case casual
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
    case poplar
    case basswood
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
      case .mahogany, .basswood:
        return 0
      case .blackLimba:
        return 150
      case .swampAsh:
        return 80
      case .poplar:
        return 50
      case .koa:
        return 100
      }
    }
  }

  enum Fretboard: String, Addition {
    static var type: String { "Fretboard" }

    case rosewood
    case maple
    case birdseyeMaple
    case flamedMaple
    case blackEbony
    case blackLimba

    var name: String {
      switch self {
      case .birdseyeMaple:
        return "Birdseye Maple"
      case .flamedMaple:
        return "Flamed Maple"
      case .blackEbony:
        return "Black Ebony"
      case .blackLimba:
        return "Black Limba"
      default:
        return rawValue.capitalized
      }
    }

    var price: Decimal {
      switch self {
      case .rosewood, .maple:
        return 0
      case .birdseyeMaple:
        return 80
      case .flamedMaple:
        return 80
      case .blackEbony:
        return 100
      case .blackLimba:
        return 120
      }
    }
  }
}

/// https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml
/// https://api.exchangeratesapi.io/latest?base=USD
public enum Currency: String {
  case usd
  case eur
  case gbp
  case ils

  var code: String { rawValue.uppercased() }
}
