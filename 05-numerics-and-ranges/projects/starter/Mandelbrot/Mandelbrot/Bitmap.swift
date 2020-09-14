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

import CoreGraphics
import Foundation

/// Abstract pixel protocol.  Provides traits of a pixel type like RGB or grayscale.
protocol PixelProtocol {
  static var bytesPerPixel: Int { get }
  static var bitsPerPixel: Int { get }
  static var alphaInfo: CGImageAlphaInfo { get }
  static var bitsPerComponent: Int { get }
  static var colorSpace: CGColorSpace { get }
}

// MARK: -

/// A concrete pixel type.
struct ColorPixel: PixelProtocol {
  var red, green, blue: UInt8
  var alpha: UInt8 = 255
  /// Protocol conformance

  static var bytesPerPixel: Int {
    MemoryLayout<Self>.stride
  }

  static var bitsPerPixel: Int {
    bytesPerPixel * bitsPerComponent
  }

  static var alphaInfo: CGImageAlphaInfo {
    CGImageAlphaInfo.premultipliedLast
  }

  static var bitsPerComponent: Int { 8 }

  static var colorSpace: CGColorSpace {
    CGColorSpaceCreateDeviceRGB()
  }

  /// A handy set of colors for debugging
  static var white: Self { ColorPixel(red: 255, green: 255, blue: 255) }
  static var black: Self { ColorPixel(red: 0, green: 0, blue: 0) }
  static var red: Self { ColorPixel(red: 255, green: 0, blue: 0) }
  static var green: Self { ColorPixel(red: 0, green: 255, blue: 0) }
  static var blue: Self { ColorPixel(red: 0, green: 0, blue: 255) }
}

// MARK: -
struct GrayscalePixel<G: BinaryInteger>: PixelProtocol {
  var value: G

  init(_ value: G) {
    self.value = value
  }

  static var bytesPerPixel: Int {
    MemoryLayout<G>.stride
  }

  static var bitsPerPixel: Int {
    bytesPerPixel * 8
  }

  static var alphaInfo: CGImageAlphaInfo {
    CGImageAlphaInfo.none
  }

  static var bitsPerComponent: Int {
    bitsPerPixel
  }

  static var colorSpace: CGColorSpace {
    CGColorSpaceCreateDeviceGray()
  }
}

// MARK: -

/// A two dimensional array of pixels in row major order.
struct Bitmap<Pixel: PixelProtocol> {
  let width: Int      ///< Width of the bitmap.
  let height: Int     ///< Height of the bitmap.
  let pixels: [Pixel] ///< Pixel data.

  /// The total number of pixels
  var pixelCount: Int { width * height }

  /// The number of bytes in a row.
  var bytesPerRow: Int {
    width * Pixel.bytesPerPixel
  }

  /// Initialize pixels with a closure.
  init(
    width: Int,
    height: Int,
    pixelInitializer: (Int, Int, inout UnsafeMutableBufferPointer<Pixel>) -> Void
  ) {
    self.width = width
    self.height = height
    self.pixels = Array(unsafeUninitializedCapacity: width * height) { buffer, count in
      pixelInitializer(width, height, &buffer)
      count = width * height
    }
  }

  /// A CoreGraphics version of the image.
  var cgImage: CGImage? {
    let data = Data(bytes: pixels, count: height * bytesPerRow) as CFData

    guard let provider = CGDataProvider(data: data) else {
      return nil
    }

    return CGImage(
      width: width,
      height: height,
      bitsPerComponent: Pixel.bitsPerComponent,
      bitsPerPixel: Pixel.bitsPerPixel,
      bytesPerRow: bytesPerRow,
      space: Pixel.colorSpace,
      bitmapInfo: CGBitmapInfo(rawValue: Pixel.alphaInfo.rawValue),
      provider: provider,
      decode: nil,
      shouldInterpolate: true,
      intent: .defaultIntent)
  }
}
