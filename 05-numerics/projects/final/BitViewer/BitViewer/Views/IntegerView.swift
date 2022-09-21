/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift
///

import SwiftUI

struct IntegerView<IntType: FixedWidthInteger>: View {
  @Binding var value: IntType
  @EnvironmentObject var preferences: Preferences

  var body: some View {
    VStack(alignment: .leading) {
      if IntType.isSigned {
        BitLegend(kind: .signedInteger)
          .padding(.bottom, 10)
      }
      if IntType.bitWidth > 8 {
        Toggle(isOn: $preferences.displayBitsStacked) {
          Text("Display bits as stacks of bytes")
        }.toggleStyle(CheckboxToggleStyle())
      }
      BitsView(value: $value, bitSemanticProvider: BitSemantic.provider(for: IntType.self))
        .padding(.bottom, 10)
      Group {
        IntegerValueExpansionView(value: value, kind: .powersOfTwo)
        Color.gray.frame(height: 1)
        IntegerValueExpansionView(value: value, kind: .evaluated)
      }.font(.system(size: 30, weight: .bold, design: .monospaced)).padding([.leading])
    }
    .padding()
    .navigationTitle(String(describing: IntType.self))
  }
}
