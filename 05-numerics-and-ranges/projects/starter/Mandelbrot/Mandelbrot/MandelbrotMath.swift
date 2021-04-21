/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Numerics
import CoreGraphics

/// Uninhabited type for Mandelbrot math related methods.
enum MandelbrotMath {
  /// Points that describe the evolution points
  static func points<RealType: Real>(start: Complex<RealType>, maxIterations: Int) -> [Complex<RealType>] {

    // TODO: implement (1)
     []
  }

  /// Compute an Mandelbrot image
  static func makeImage<RealType: Real & CGFloatConvertable>(
    for realType: RealType.Type,
    imageSize: CGSize,
    displayToModel: CGAffineTransform,
    maxIterations: Int,
    palette: PixelPalette
  ) -> CGImage? {

    // TODO: implement (2)
    nil
  }

  static func makeImageSIMD8_Float64(
    imageSize: CGSize,
    displayToModel: CGAffineTransform,
    maxIterations: Int,
    palette: PixelPalette
  ) -> CGImage? {

    // TODO: implement (3)
    nil

  }
}
