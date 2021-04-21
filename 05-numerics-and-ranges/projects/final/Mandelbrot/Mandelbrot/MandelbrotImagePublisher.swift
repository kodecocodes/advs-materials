/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Combine
import CoreGraphics
import SwiftUI  // CACurrentMediaTime

extension Publishers {
  private final class MandelbrotSubscription
  <S: Subscriber>: Subscription where S.Input == MandelbrotImage? {
    var subscriber: S?
    var description: MandelbrotDescription
    var work: DispatchWorkItem?

    init(subscriber: S, description: MandelbrotDescription) {
      self.subscriber = subscriber
      self.description = description
    }

    func request(_ demand: Subscribers.Demand) {
      work = DispatchWorkItem(flags: .inheritQoS) { [weak self, description] in
        let startTime = CACurrentMediaTime()

        let result: CGImage?
        switch description.floatSize {
        case .float16:
          result = MandelbrotMath.makeImage(
            for: Float16.self,
            imageSize: description.imageSize,
            displayToModel: description.displayToModel,
            maxIterations: description.maxIterations,
            palette: description.palette)
        case .float32:
          result = MandelbrotMath.makeImage(
            for: Float32.self,
            imageSize: description.imageSize,
            displayToModel: description.displayToModel,
            maxIterations: description.maxIterations,
            palette: description.palette)
        case .float64:
          result = MandelbrotMath.makeImage(
            for: Float64.self,
            imageSize: description.imageSize,
            displayToModel: description.displayToModel,
            maxIterations: description.maxIterations,
            palette: description.palette)
        case .simd8Float64:
          result = MandelbrotMath.makeImageSIMD8_Float64(
            imageSize: description.imageSize,
            displayToModel: description.displayToModel,
            maxIterations: description.maxIterations,
            palette: description.palette)
        case .float80:
          #if arch(x86_64)
          result = MandelbrotMath.makeImage(
            for: Float80.self,
            imageSize: description.imageSize,
            displayToModel: description.displayToModel,
            maxIterations: description.maxIterations,
            palette: description.palette)
          #else
          fatalError("logic error")
          #endif
        }

        let time = CACurrentMediaTime() - startTime

        let image = result.map { MandelbrotImage(image: $0, computationTime: time) }
        _ = self?.subscriber?.receive(image)
      }

      work.map { DispatchQueue.global(qos: .userInitiated).async(execute: $0) }
    }

    func cancel() {
      work?.cancel()
      subscriber?.receive(completion: .finished)
      subscriber = nil
    }
  }

  struct MandelbrotImagePublisher: Publisher {
    // swiftlint:disable nesting
    typealias Output = MandelbrotImage?
    typealias Failure = Never
    // swiftlint:enable nesting

    var description: MandelbrotDescription

    init(description: MandelbrotDescription) {
      self.description = description
    }

    func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
      let subsciption = MandelbrotSubscription(subscriber: subscriber, description: description)
      subscriber.receive(subscription: subsciption)
    }
  }
}
