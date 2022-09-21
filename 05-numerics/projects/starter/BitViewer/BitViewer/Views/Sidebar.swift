/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

struct Sidebar: View {
  @ObservedObject var model: ModelStore

  let integerTypes = TypeSelection.allCases.filter(\.isInteger)
  let floatingPointTypes = TypeSelection.allCases.filter(\.isFloatingPoint)

  func checkboxImage(for item: TypeSelection) -> some View {
    item == model.selection ? Image(systemName: "checkmark.square") : Image(systemName: "square")
  }

  var body: some View {
    List {
      Section(header: Text("Integer Types")) {
        ForEach(integerTypes, id: \.title) { item in
          HStack {
            checkboxImage(for: item)
            Button(item.title) {
              model.selection = item
            }
          }
        }
      }
      Section(header: Text("Floating Point Types")) {
        ForEach(floatingPointTypes, id: \.title) { item in
          HStack {
            checkboxImage(for: item)
            Button(item.title) {
              model.selection = item
            }
          }
        }
      }
    }.listStyle(SidebarListStyle())
  }
}
