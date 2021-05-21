/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI
import Combine

struct BuildView: View {
  var body: some View {
    NavigationView {
      ZStack(alignment: .bottom) {
        ScrollView {
          GuitarView(Guitar(shape: .casual,
                            color: .natural,
                            body: .mahogany,
                            fretboard: .rosewood))
        }
        .padding(.bottom, 40)

        ActionButton("Checkout") {
 
        }
      }
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
