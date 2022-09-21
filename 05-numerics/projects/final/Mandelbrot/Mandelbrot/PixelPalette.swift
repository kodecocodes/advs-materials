/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Numerics


enum PixelPaletteName: CaseIterable {
  case blackAndWhite, color

  var name: String {
    switch self {
    case .blackAndWhite:
      return "Black and White"
    case .color:
      return "Color"
    }
  }

  var palette: PixelPalette {
    switch self {
    case .blackAndWhite:
      return PixelPalette.blackAndWhite
    case .color:
      return PixelPalette.color
    }
  }
}

struct PixelPalette {
  var values: [ColorPixel]
}

extension PixelPalette {

  static let blackAndWhite: Self = {
    return PixelPalette(values:
                          (0..<16).reversed().map { index in
      ColorPixel(
        red: index*16,
        green: index*16,
        blue: index*16)
    })
  }()

  static let color: Self = {
    let ramp = { (index: Int) -> UInt8 in
      UInt8(16 * (16 - (index - 16).magnitude))
    }
    let zero = { (index: Int) -> UInt8 in 0 }

    let lookupsList = [
      (ramp, zero, ramp),
      (zero, ramp, zero),
      (zero, zero, ramp),
      (ramp, ramp, zero),
      (zero, ramp, ramp),
      (ramp, zero, ramp),
      (ramp, ramp, ramp),
      (ramp, zero, zero)
    ]

    return PixelPalette(
      values: lookupsList.reduce(into: [ColorPixel]()) { result, lookups in
        result.append(contentsOf: (0..<16).map { index in
          ColorPixel(
            red: lookups.0(index),
            green: lookups.1(index),
            blue: lookups.2(index))
        })
      }
    )
  }()
}
