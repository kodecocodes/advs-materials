/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import CoreGraphics
import Foundation

// MARK: -

/// A two dimensional array of pixels in row major order.
struct Bitmap<Pixel> {
  let width: Int      ///< Width of the bitmap.
  let height: Int     ///< Height of the bitmap.
  internal var pixels: [Pixel] ///< Pixel data.

  /// The total number of pixels
  var pixelCount: Int { width * height }

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

  /// Initialize from a 1D set of pixel data in row major order.
  ///   - `width` must be an even multiple of the total size of pixel data
  init(pixels: [Pixel], width: Int) {
    precondition(pixels.count % width == 0, "the pixels array size must be a multiple of the width")
    self.width = width
    self.height = pixels.count / width
    self.pixels = pixels
  }

  /// Initialize bitmap with a single pixel value.
  init(width: Int, height: Int, fill pixel: Pixel) {
    self.width = width
    self.height = height
    self.pixels = Array(repeating: pixel, count: width*height)
  }

  /// Set all of the pixels to a specific value.
  mutating func set(_ pixel: Pixel) {
    pixels.indices.forEach {
      pixels[$0] = pixel
    }
  }
}

// MARK: -

/// Abstract pixel protocol.  Provides traits of a pixel type like RGB or grayscale.
protocol PixelProtocol {
  static var bytesPerPixel: Int { get }
  static var bitsPerPixel: Int { get }
  static var alphaInfo: CGImageAlphaInfo { get }
  static var bitsPerComponent: Int { get }
  static var colorSpace: CGColorSpace { get }
}

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
}

// MARK: -
/// Bitmaps that use pixels types conforming to the `PixelProtocol`
/// can create core graphics images.
extension Bitmap where Pixel: PixelProtocol {

  /// The number of bytes in a row.
  var bytesPerRow: Int {
    width * Pixel.bytesPerPixel
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
      shouldInterpolate: false,
      intent: .defaultIntent)
  }
}

// MARK: -

/// Equatable
extension Bitmap: Equatable where Pixel: Equatable {
}

