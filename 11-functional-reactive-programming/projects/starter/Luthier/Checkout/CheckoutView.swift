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

import SwiftUI
import Combine

struct CheckoutView: View {
  @ObservedObject var viewModel: CheckoutViewModel
  @Environment(\.presentationMode) var presentationMode

  init(info: CheckoutInfo) {
    self.viewModel = CheckoutViewModel(info: info)
  }
  
  var body: some View {
    NavigationView {
      ZStack(alignment: .bottom) {
        Form {
          Section(header: Text("Your Guitar")) {
            let guitar = viewModel.guitar

            TextRow("Shape",
                    guitar.shape.pricedName)

            TextRow("Color",
                    guitar.color.pricedName)

            TextRow("Body",
                    guitar.body.pricedName)

            TextRow("Fretboard",
                    guitar.fretboard.pricedName)
          }

          Section(header: Text("Order details")) {
            TextRow("Estimated build time",
                    viewModel.buildEstimate)

            TextRow("Availability",
                    viewModel.isAvailable
                      ? "Available"
                      : "Currently unavailable")
          }

          Section(header: Text("Shipping")) {
            Picker(selection: $viewModel.selectedShippingOption,
                   label: Text("Shipping method")) {
              ForEach(Array(viewModel.shippingPrices.keys),
                      id: \.self) { option in
                let price = viewModel.shippingPrices[option] ?? "N/A"
                Text("\(option.name) (\(price))").tag(option)
              }
            }

            TextRow("Time", viewModel.selectedShippingOption.duration)
          }

          Section(header: Text("Totals")) {
            HStack {
              Text("Currency")
              Spacer(minLength: 16)
              Text(Currency.usd.symbol)
            }

            TextRow("Base price",
                    viewModel.guitar.price.formatted)

            TextRow("Additions",
                    viewModel.guitar.additionsPrice.formatted)

            TextRow("Shipping",
                    viewModel.selectedShippingOption.price.formatted)

            TextRow("Grand total",
                    (viewModel.guitar.price +
                     viewModel.guitar.additionsPrice +
                     viewModel.selectedShippingOption.price).formatted,
                    weight: .semibold)
          }
        }
        .padding(.bottom, 40)

        ActionButton(
          viewModel.checkoutButton,
          isLoading: false,
          color: viewModel.isAvailable ? .green : .red
        ) {
          
        }
      }
      .disabled(!viewModel.isAvailable)
      .navigationTitle("Your guitar")
    }
  }
}

struct TextRow: View {
  private let title: String
  private let value: String
  private let weight: Font.Weight?
  private let isLoading: Bool

  init(_ title: String,
       _ value: String,
       weight: Font.Weight? = nil,
       isLoading: Bool = false) {
    self.title = title
    self.value = value
    self.weight = weight
    self.isLoading = isLoading
  }

  var body: some View {
    HStack {
      Text(title).fontWeight(weight)
      Spacer()
      
      if isLoading {
        Text("-----")
          .fontWeight(weight)
          .redacted(reason: .placeholder)
      } else {
        Text(value).fontWeight(weight)
      }
    }
  }
}
