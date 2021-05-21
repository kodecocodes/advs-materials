/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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
