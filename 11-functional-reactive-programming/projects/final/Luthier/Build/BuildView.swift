/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI
import Combine

struct BuildView: View {
  @StateObject var viewModel = BuildViewModel()
  
  var body: some View {
    NavigationView {
      ZStack(alignment: .bottom) {
        ScrollView {
          GuitarView(viewModel.guitar)
          
          VStack(alignment: .center) {
            additionPicker(
              for: Guitar.Shape.self,
              selection: $viewModel.selectedShapeIdx
            )
            
            additionPicker(
              for: Guitar.Color.self,
              selection: $viewModel.selectedColorIdx
            )
            
            additionPicker(
              for: Guitar.Body.self,
              selection: $viewModel.selectedBodyIdx
            )
            
            additionPicker(
              for: Guitar.Fretboard.self,
              selection: $viewModel.selectedFretboardIdx
            )
            
            Spacer()
          }
        }
        .padding(.bottom, 40)

        ActionButton("Checkout (\(viewModel.guitar.price.formatted))",
                     isLoading: viewModel.isLoadingCheckout) {
          viewModel.checkout()
        }
      }
      .sheet(
        item: $viewModel.checkoutInfo,
        onDismiss: { viewModel.clear() },
        content: { info in
          CheckoutView(info: info)
        }
      )
      .navigationTitle("Build your guitar")
    }
  }

  private func additionPicker<A: Addition>(
    for addition: A.Type,
    selection: Binding<Int>
  ) -> some View {
    let options = addition.allCases

    return VStack(alignment: .center) {
      Text(addition.type).font(.subheadline)

      Picker(options[selection.wrappedValue].pricedName,
             selection: selection) {
        ForEach((0..<options.count)) { idx in
          let addition = options[idx]
          Text(addition.pricedName).tag(idx)
        }
      }
      .animation(.none)
      .pickerStyle(MenuPickerStyle())
    }
    .frame(maxWidth: .infinity)
    .padding()
  }
}
