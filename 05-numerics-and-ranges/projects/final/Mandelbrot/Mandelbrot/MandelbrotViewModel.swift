/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift


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
    return [.float16, .float32, .float64, .float80, .simd8Float64]
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
  @Published var maxIterations: CGFloat = 15
  @Published var floatSize: FloatSize = .float64
  @Published var paletteName: PixelPaletteName = .color

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

    guard let width = imageSize?.width, width > 0 else {
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
      Publishers.CombineLatest3($maxIterations, $floatSize, $paletteName))
      .map { [weak self] combined -> AnyPublisher<MandelbrotImage?, Never> in
        let ((showImage, center, scale, imageSizeOptional), (maxIterations, floatSize, paletteName)) = combined
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
          palette: paletteName.palette)
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
    ("Divergent", CGPoint(x: -2, y: 0.5)),
    ("One iteration", CGPoint(x: 0.88, y: 0.71)),
    ("Two iterations", CGPoint(x: 0.556, y: 0.679)),
    ("Many iterations", CGPoint(x: -0.673, y: -0.343)),
    ("Float16 Different Path", CGPoint(x: -0.9567, y: -0.2667)),
    ("All Sizes Different Paths", CGPoint(x: -1.533, y: 8.326672684688674e-17))
  ]}
}
