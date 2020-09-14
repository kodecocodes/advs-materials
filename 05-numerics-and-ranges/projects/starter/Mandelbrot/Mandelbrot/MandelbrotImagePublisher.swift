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
