/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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
