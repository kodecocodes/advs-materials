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

struct CheckoutView: View {
  @ObservedObject var viewModel: CheckoutViewModel

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

          let shipping = viewModel.selectedShippingOption

          Section(header: Text("Shipping")) {
            Picker(selection: $viewModel.selectedShippingOption,
                   label: Text("Shipping method")) {
              ForEach(Array(viewModel.shippingOptionsPrices.keys), id: \.self) { option in
                let price = viewModel.shippingOptionsPrices[option] ?? "N/A"
                Text("\(option.name) (\(price))").tag(option)
              }
            }
            TextRow("Time", shipping.duration)
          }

          Section(header: Text("Totals")) {
            HStack {
              Text("Currency")
              Spacer(minLength: 16)
              Picker("Currency",
                     selection: $viewModel.currency) {
                ForEach(Currency.allCases) {
                  Text($0.symbol).tag($0)
                }
              }
              .pickerStyle(SegmentedPickerStyle())
            }

            TextRow("Base price",
                    viewModel.basePrice)

            TextRow("Additions",
                    viewModel.additionsPrice)

            TextRow("Shipping",
                    viewModel.shippingPrice)

            TextRow("Grand total",
                    viewModel.totalPrice,
                    weight: .semibold)
          }
        }
        .disabled(viewModel.isUpdatingCurrency)
        .padding(.bottom, 40)

        let buttonColor = viewModel.isAvailable
          ? Color.green : Color.red

        Button(viewModel.checkoutButton) {

        }
        .foregroundColor(.white)
        .font(.system(size: 28,
                      weight: .semibold,
                      design: .rounded))
        .frame(maxWidth: .infinity,
               maxHeight: 64)
        .background(buttonColor.edgesIgnoringSafeArea(.bottom))
        .disabled(!viewModel.isAvailable || viewModel.isUpdatingCurrency)
      }
      .navigationTitle("Your guitar")
    }
  }
}

struct TextRow: View {
  private let title: String
  private let value: String
  private let weight: Font.Weight?

  init(_ title: String,
       _ value: String,
       weight: Font.Weight? = nil) {
    self.title = title
    self.value = value
    self.weight = weight
  }

  var body: some View {
    HStack {
      Text(title).fontWeight(weight)
      Spacer()
      Text(value).fontWeight(weight)
    }
  }
}

#if DEBUG
struct CheckoutView_Previews: PreviewProvider {
  static var previews: some View {
    CheckoutView(
      viewModel: CheckoutViewModel(
        checkoutInfo: CheckoutInfo(
          guitar: .init(
            shape: .casual,
            color: .dusk,
            body: .basswood,
            fretboard: .birdseyeMaple),
          shippingOptions: [
            .init(name: "Method 1", duration: "6-8 weeks", price: 100),
            .init(name: "Method 2", duration: "1 month", price: 120),
            .init(name: "Method 3", duration: "4-6 days", price: 250)
          ],
          buildEstimate: "12 months",
          isAvailable: true
        )
      )
    )
  }
}
#endif
