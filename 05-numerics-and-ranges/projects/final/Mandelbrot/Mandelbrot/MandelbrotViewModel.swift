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


import SwiftUI
import Combine
import Numerics
import Foundation

// The types that your algorithms can choose from.
enum FloatSize: String {
  case float16
  case float32
  case float64
  case simd8Float64
  case float80

  static var pathSizes: [Self] {
    #if arch(x86_64)
    return [.float16, .float32, .float64, .float80]
    #else
    return [.float16, .float32, .float64]
    #endif
  }

  static var imageSizes: [Self] {
    #if arch(x86_64)
    return [.float16, .float32, .float64, .float80, .simd8_float64]
    #else
    return [.float16, .float32, .float64, .simd8Float64]
    #endif
  }

  var name: String {
    switch self {
    case .float16:
      return "16"
    case .float32:
      return "32"
    case .float64:
      return "64"
    case .float80:
      return "80"
    case .simd8Float64:
      return "8x64"
    }
  }
}

struct MandelbrotImage {
  var image: CGImage
  var computationTime: TimeInterval
}

struct MandelbrotDescription {
  var center: CGPoint
  var scale: CGFloat
  var imageSize: CGSize
  var maxIterations: Int
  var floatSize: FloatSize
  var palette: PixelPalette

  var displayToModel: CGAffineTransform {
    CGAffineTransform.makeModelToDisplay(
      displaySize: imageSize,
      center: center,
      pointsPerModelUnit: scale)
      .inverted()
  }

  func publisher() -> AnyPublisher<MandelbrotImage?, Never> {
    Publishers.MandelbrotImagePublisher(description: self).eraseToAnyPublisher()
  }
}

final class MandelbrotViewModel: ObservableObject {
  @Published var showImage = false
  @Published var center = CGPoint.zero
  @Published var scale: CGFloat = 150
  @Published var imageSize: CGSize?
  @Published var maxIterations: CGFloat = 16
  @Published var floatSize: FloatSize = .float64

  @Published var isComputingImage = false
  @Published var computationTime: TimeInterval?

  @Published var showTestPoint = true
  @Published var testPoint = CGPoint.zero

  // Image that is  computed via a combined publisher
  @Published var image: CGImage?
  var subscriptions = Set<AnyCancellable>()

  // Handle automatic grid resizing
  var gridPitch: CGFloat {
    let minimumNumberOfLines: CGFloat = 2
    let maximumNumberOfLines: CGFloat = 10

    guard let width = imageSize?.width else {
      return 1
    }
    let lower = Int((log10(width / (maximumNumberOfLines * scale)).rounded()))
    let upper = Int((log10(width / (minimumNumberOfLines * scale)).rounded()))
    return pow(CGFloat(10), CGFloat((upper - lower) / 2 + lower))
  }

  init() {
    // swiftlint:disable:next trailing_closure
    Publishers.CombineLatest(
      Publishers.CombineLatest4($showImage, $center, $scale, $imageSize),
      Publishers.CombineLatest($maxIterations, $floatSize))
      .map { [weak self] combined -> AnyPublisher<MandelbrotImage?, Never> in
        let ((showImage, center, scale, imageSizeOptional), (maxIterations, floatSize)) = combined
        guard showImage, let imageSize = imageSizeOptional else {
          return Just(nil).eraseToAnyPublisher()
        }
        self?.isComputingImage = true
        let mandelbrot = MandelbrotDescription(
          center: center,
          scale: scale,
          imageSize: imageSize,
          maxIterations: Int(maxIterations),
          floatSize: floatSize,
          palette: .rainbow)
        return mandelbrot.publisher()
      }
      .switchToLatest()
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] mandelbrot in
        self?.isComputingImage = false
        self?.image = mandelbrot?.image
        self?.computationTime = mandelbrot?.computationTime
      })
      .store(in: &subscriptions)
  }
}

extension MandelbrotViewModel {
  var landmarks: [(String, CGPoint)] { [
    ("All Float Sizes Converge",
    CGPoint(x: -0.6, y: 0.33333333333333337)),
    ("All Float Sizes Diverge",
    CGPoint(x: -2.116666666666667, y: 0.4700000000000001)),
    ("Slower Convergence",
    CGPoint(x: -0.6733333333333333, y: -0.3433333333333333)),
    ("Float16 Different Path",
    CGPoint(x: -0.9566666666666667, y: -0.26666666666666666)),
    ("All Sizes Different Paths",
    CGPoint(x: -1.5333333333333339, y: 8.326672684688674e-17))
  ]}
}
