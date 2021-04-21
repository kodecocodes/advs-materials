/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI

struct IntegerOperationsView<IntType: FixedWidthInteger>: View {
  @Binding var value: IntType

  var body: some View {
    List {
      ForEach(IntegerOperation<IntType>.menu, id: \.title) { section in
        Section(header: Text(section.title)) {
          ForEach(section.items, id: \.name) { item in
            HStack {
              Image(systemName: "function")
              Button(item.name) {
                value = item.operation(value)
              }
            }
          }
        }
      }
    }.listStyle(GroupedListStyle())
    .navigationTitle("\(String(describing: IntType.self)) Operations")
  }
}

struct FloatingPointOperationsView<FloatType: BinaryFloatingPoint & DoubleConvertable>: View {
  @Binding var value: FloatType

  var body: some View {
    List {
      ForEach(FloatingPointOperation<FloatType>.menu, id: \.title) { section in
        Section(header: Text(section.title)) {
          ForEach(section.items, id: \.name) { item in
            HStack {
              Image(systemName: "function")
              Button(item.name) {
                value = item.operation(value)
              }
            }
          }
        }
      }
    }.listStyle(GroupedListStyle())
    .navigationViewStyle(StackNavigationViewStyle())
    .navigationTitle("\(String(describing: FloatType.self)) Operations")
  }
}
