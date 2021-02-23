/// Copyright (c) 2021 Razeware LLC
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

class BuildViewModel: ObservableObject {
  // Bindings / State
  @Published var selectedShapeIdx = 0
  @Published var selectedColorIdx = 0
  @Published var selectedBodyIdx = 0
  @Published var selectedFretboardIdx = 0
  
  // Outputs
  @Published private(set) var guitar = Guitar(
    shape: .casual,
    color: .natural,
    body: .mahogany,
    fretboard: .rosewood
  )
  @Published private(set) var isLoadingCheckout = false
  @Published var checkoutInfo: CheckoutInfo?

  private let shouldCheckout = PassthroughSubject<Void, Never>()
  private let guitarService = GuitarService()
  
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
    
    let availability = guitarService
      .ensureAvailability(for: guitar)
      .handleEvents(
        receiveOutput: { print("available? \($0)") }
      )
    
    let estimate = guitarService
      .getBuildTimeEstimate(for: guitar)
      .handleEvents(
        receiveOutput: { print("estimate: \($0)") }
      )

    let shipment = guitarService
      .getShipmentOptions()
      .handleEvents(
        receiveOutput: { print("shipment \($0.map(\.name))") }
      )
    
    let response = shouldCheckout
      .flatMap { shipment.zip(estimate, availability) }
      .map {
        CheckoutInfo(
          guitar: self.guitar,
          shippingOptions: $0,
          buildEstimate: $1,
          isAvailable: $2
        )
      }
      .share()
    
    Publishers
      .Merge(shouldCheckout.map { _ in true },
             response.map { _ in false })
      .assign(to: &$isLoadingCheckout)
    
    response
     .map { $0 as CheckoutInfo? }
     .assign(to: &$checkoutInfo)
  }
  
  func clear() {
    selectedShapeIdx = 0
    selectedColorIdx = 0
    selectedBodyIdx = 0
    selectedFretboardIdx = 0
  }
  
  func checkout() {
   shouldCheckout.send()
 }
}
