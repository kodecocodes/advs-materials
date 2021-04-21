/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI

private extension BinaryFloatingPoint {
  var bias: Int {
    Int(pow(2.0, Double(Self.exponentBitCount - 1))) - 1
  }

  var formattedExponent: String {
    if self.isZero {
      return "Int.min"
    } else if self.isInfinite || self.isNaN {
      return "Int.max"
    } else {
      return "\(exponentBitPattern)-\(bias) = \(self.exponent)"
    }
  }

  var evaluatedComponents: String {
    guard !(self.isInfinite || self.isNaN || self.isZero) else {
      return "Special case"
    }

    return String(describing: self.significand) + " ⋅ " + String(Self.radix) +
      superscript(Int(self.exponent)) + " = " + String(describing: self)
  }
}

typealias FloatingPointViewConstraints = BinaryFloatingPoint & BitPatternConvertable & DoubleConvertable

struct FloatingPointView<FloatType: FloatingPointViewConstraints>: View {
  @Binding var value: FloatType
  @EnvironmentObject var preferences: Preferences

  let font: Font = .system(size: 25, weight: .bold, design: .monospaced)

  func bindingToBitPattern() -> Binding<FloatType.BitPattern> {
    Binding(get: { value.bitPattern }, set: { value = FloatType(bitPattern: $0) })
  }

  func bitSemanticProvider() -> (Int) -> BitSemantic? {
    BitSemantic.provider(for: FloatType.self)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack(alignment: .top) {
        BitLegend(kind: .floatingPoint)
      }

      Toggle(isOn: $preferences.displayBitsStacked) {
        Text("Display bits as stacks of bytes")
      }.toggleStyle(CheckboxToggleStyle())

      BitsView(value: bindingToBitPattern(), bitSemanticProvider: bitSemanticProvider())

      Text("Attributes").font(font)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 6) {
          AttributeLabelView("isZero", isOn: value.isZero)
          AttributeLabelView("isNan", isOn: value.isNaN)
          AttributeLabelView("isSignalingNaN", isOn: value.isSignalingNaN)
          AttributeLabelView("isInfinite", isOn: value.isInfinite)
          AttributeLabelView("isFinite", isOn: value.isFinite)
          AttributeLabelView("isCanonical", isOn: value.isCanonical)
          AttributeLabelView("isNormal", isOn: value.isNormal)
          AttributeLabelView("isSubnormal", isOn: value.isSubnormal)
        }
      }
      VStack(alignment: .leading, spacing: 10) {
        Text(" Describing: \(String(describing: value))")
        Text("       Full: \(String(format: "%.30g", value.asDouble()))")
        Text("        Hex: 0x\(String(value.bitPattern, radix: 16).uppercased())")
        Text("       Bias: \(value.bias)")
        Text("   Exponent: \(value.formattedExponent)")
        Text("      Radix: \(String(FloatType.radix))")
        Text("Significand: \(String(describing: value.significand))")
        Text("  Evaluated: \(value.evaluatedComponents)")
      }.font(font).padding([.leading])
    }
    .padding()
    .navigationTitle(String(describing: FloatType.self))
  }
}
