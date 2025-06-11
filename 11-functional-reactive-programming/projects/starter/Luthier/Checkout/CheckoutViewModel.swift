/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import Combine
import Foundation

@dynamicMemberLookup
class CheckoutViewModel: ObservableObject {
  private let info: CheckoutInfo
  
  // Input/Bindings
  @Published var selectedShippingOption = ShippingOption(
    name: "",
    duration: "",
    price: 0
  )

  // Outputs
  @Published var shippingPrices = [ShippingOption: String]()
  
  var checkoutButton: String {
    self.isAvailable ? "Order now" : "Model unavailable"
  }
  
  init(info: CheckoutInfo) {
    self.info = info
    
    self.selectedShippingOption = self.shippingOptions[0]
    self.shippingPrices = self.shippingOptions
      .reduce(into: [ShippingOption: String]()) { options, option in
        options[option] = option.price == 0
          ? "Free"
          : option.price.formatted
      }
  }
  
  subscript<T>(dynamicMember keyPath: KeyPath<CheckoutInfo, T>) -> T {
    info[keyPath: keyPath]
  }
}
