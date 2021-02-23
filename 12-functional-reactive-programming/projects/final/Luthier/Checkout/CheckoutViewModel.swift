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
import Foundation

@dynamicMemberLookup
class CheckoutViewModel: ObservableObject {
  // Input/Bindings
  @Published var selectedShippingOption = ShippingOption(name: "",
                                                         duration: "",
                                                         price: 0)
  @Published var currency = Currency.usd

  // Outputs
  @Published var shippingPrices = [ShippingOption: String]()
  @Published var basePrice = ""
  @Published var additionsPrice = ""
  @Published var totalPrice = ""
  @Published var shippingPrice = ""
  @Published var isUpdatingCurrency = false
  @Published var isOrdering = false
  @Published var didOrder = false
  private let shouldOrder = PassthroughSubject<Void, Never>()
  
  private let info: CheckoutInfo
  private let currencyService = CurrencyService()
  private let guitarService = GuitarService()
  
  var checkoutButton: String {
    self.isAvailable ? "Order now" : "Model unavailable"
  }
  
  init(info: CheckoutInfo) {
    self.info = info
    
    self.selectedShippingOption = self.shippingOptions[0]
    
    let currency = $currency
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .removeDuplicates()
    
    let currencyAndRate = currency
      .flatMap { currency -> AnyPublisher<(Currency, Decimal), Never> in
        guard currency != .usd else {
          return Just((currency, 1.0)).eraseToAnyPublisher()
        }
        
        return self.currencyService
          .getExchangeRate(for: currency)
          .map { (currency, $0) }
          .replaceError(with: (.usd, 1.0))
          .eraseToAnyPublisher()
      }
      .receive(on: RunLoop.main)
      .share()
    
    currencyAndRate
      .map { currency, rate in
        (Guitar.basePrice * rate).formatted(for: currency)
      }
      .assign(to: &$basePrice)
    
    currencyAndRate
      .map { currency, rate in
        (self.guitar.additionsPrice * rate).formatted(for: currency)
      }
      .assign(to: &$additionsPrice)
    
    currencyAndRate
      .map { [weak self] currency, rate in
        guard let self = self else { return "N/A" }

        let totalPrice = self.guitar.price +
                         self.selectedShippingOption.price
        
        let exchanged = totalPrice * rate
        return exchanged.formatted(for: currency)
      }
      .assign(to: &$totalPrice)
    
    currencyAndRate
      .map { [weak self] currency, rate in
        guard let self = self else { return [:] }

        return self.shippingOptions
          .reduce(into: [ShippingOption: String]()) { opts, opt in
            opts[opt] = opt.price == 0
              ? "Free"
              : (opt.price * rate).formatted(for: currency)
          }
      }
      .assign(to: &$shippingPrices)

    $shippingPrices
      .combineLatest($selectedShippingOption, $isUpdatingCurrency)
      .map { pricedOptions, selectedOption, isLoading in
        guard selectedOption.price != 0 else { return "Free" }
        return pricedOptions[selectedOption] ?? "N/A"
      }
      .assign(to: &$shippingPrice)
    
    Publishers.Merge(
      currency.dropFirst().map { _ in true },
      currencyAndRate.map { _ in false }
    )
    .assign(to: &$isUpdatingCurrency)
    
    let orderResponse = shouldOrder
      .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
        self.map { $0.guitarService.order($0.guitar) } ??
        Empty().eraseToAnyPublisher()
      }
      .share()

    Publishers.Merge(
      shouldOrder.map { true },
      orderResponse.map { false }
    )
    .assign(to: &$isOrdering)

    orderResponse
      .map { true }
      .assign(to: &$didOrder)
  }
  
  func order() {
    shouldOrder.send()
  }
  
  subscript<T>(dynamicMember keyPath: KeyPath<CheckoutInfo, T>) -> T {
    info[keyPath: keyPath]
  }
}
