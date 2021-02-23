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

struct BuildView: View {
  @ObservedObject var viewModel = BuildViewModel()
  
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
