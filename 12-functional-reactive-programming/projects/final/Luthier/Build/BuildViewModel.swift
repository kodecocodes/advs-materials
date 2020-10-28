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
import Foundation

class BuildViewModel: ObservableObject {
  // Bindings / State
  @Published var selectedShapeIdx = 0
  @Published var selectedColorIdx = 0
  @Published var selectedBodyIdx = 0
  @Published var selectedFretboardIdx = 0
  @Published var checkoutInfo: CheckoutInfo?

  // Output
  @Published private(set) var guitar: Guitar = .init(shape: .casual,
                                                     color: .dusk,
                                                     body: .basswood,
                                                     fretboard: .birdseyeMaple)
  @Published private(set) var price = "N/A"
  @Published private(set) var isLoadingCheckout = false

  private let shouldCheckout = PassthroughSubject<Void, Never>()

  private let service = GuitarService()
  private var subscriptions = Set<AnyCancellable>()

  init() {
    $selectedShapeIdx
      .combineLatest($selectedColorIdx,
                     $selectedBodyIdx,
                     $selectedFretboardIdx)
      .map { shapeIdx, colorIdx, bodyIdx, fbIdx in
        Guitar(
          shape: Guitar.Shape.allCases[shapeIdx],
          color: Guitar.Color.allCases[colorIdx],
          body: Guitar.Body.allCases[bodyIdx],
          fretboard: Guitar.Fretboard.allCases[fbIdx]
        )
      }
      .assign(to: &$guitar)

    $guitar
      .map(\.price.formatted)
      .assign(to: &$price)

    let availability = service
      .ensureAvailability(for: guitar)
      .handleEvents(
        receiveOutput: { _ in print("availability") }
      )

    let estimate = service
      .getBuildTimeEstimate(for: guitar)
      .handleEvents(
        receiveOutput: { _ in print("estimate") }
      )

    let shipment = service
      .getShipmentOptions()
      .handleEvents(
        receiveOutput: { _ in print("shipment") }
      )

    let response = shouldCheckout
      .flatMap { shipment.zip(estimate, availability) }
      .map { CheckoutInfo(guitar: self.guitar,
                          shippingOptions: $0,
                          buildEstimate: $1,
                          isAvailable: $2) }
      .share()

    $checkoutInfo
      .print("x")
      .sink(receiveValue: { _ in })
      .store(in: &subscriptions)

    response
      .map { $0 as CheckoutInfo? }
      .assign(to: &$checkoutInfo)

    Publishers
      .Merge(shouldCheckout.map { _ in true },
             response.map { _ in false })
      .assign(to: &$isLoadingCheckout)
  }

  func checkout() {
    shouldCheckout.send()
  }

  func clear() {
    selectedShapeIdx = 0
    selectedColorIdx = 0
    selectedBodyIdx = 0
    selectedFretboardIdx = 0
  }
}

