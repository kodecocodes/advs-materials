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
