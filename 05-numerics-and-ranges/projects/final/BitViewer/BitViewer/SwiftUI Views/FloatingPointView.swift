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

private extension FloatingPoint {
  var formattedExponent: String {
    if self.isZero {
      return "Int.min"
    } else if self.isInfinite || self.isNaN {
      return "Int.max"
    } else {
      return String(self.exponent)
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

struct FloatingPointView<FloatType: BinaryFloatingPoint & BitPatternConvertable & DoubleConvertable>: View {
  @Binding var value: FloatType
  @EnvironmentObject var preferences: Preferences

  let font: Font = .system(size: 25, weight: .bold, design: .monospaced)

  var spacer: some View {
    Color.clear.frame(height: 10)
  }

  func bindingToBitPattern() -> Binding<FloatType.BitPattern> {
    Binding(get: { value.bitPattern }, set: { value = FloatType(bitPattern: $0) })
  }

  func bitSemanticProvider() -> (Int) -> BitSemantic? {
    BitSemantic.provider(for: FloatType.self)
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top, spacing: 40) {
        BitLegend(kind: .floatingPoint)
        VStack(alignment: .leading, spacing: 10) {
          Text("      Radix: \(String(FloatType.radix))")
          Text("   Exponent: \(value.formattedExponent)")
          Text("Significand: \(String(describing: value.significand))")
        }.font(font)
      }
      Toggle(isOn: $preferences.displayBitsStacked) {
        Text("Display bits as stacks of bytes")
      }.toggleStyle(CheckboxToggleStyle())

      BitsView(value: bindingToBitPattern(), bitSemanticProvider: bitSemanticProvider())

      spacer

      Text("Attributes").font(font)
      ScrollView(.horizontal) {
        LazyHGrid(rows: [GridItem(.fixed(35))], spacing: 6) {
          AttributeLabelView(isOn: value.isZero, labelText: "isZero", color: .black)
          AttributeLabelView(isOn: value.isNaN, labelText: "isNan", color: .black)
          AttributeLabelView(isOn: value.isSignalingNaN, labelText: "isSignalingNaN", color: .red)
          AttributeLabelView(isOn: value.isInfinite, labelText: "isInfinite", color: .black)
          AttributeLabelView(isOn: value.isFinite, labelText: "isFinite", color: .black)
          AttributeLabelView(isOn: value.isCanonical, labelText: "isCanonical", color: .black)
          AttributeLabelView(isOn: value.isNormal, labelText: "isNormal", color: .black)
          AttributeLabelView(isOn: value.isSubnormal, labelText: "isSubnormal", color: .black)
        }
      }
      VStack(alignment: .leading, spacing: 10) {
        Text("Describing: \(String(describing: value))")
        Text("Underlying: \(String(format: "%.30g", value.asDouble()))")
        Text("       Hex: 0x\(String(value.bitPattern, radix: 16).uppercased())")
        Text(" Evaluated: \(value.evaluatedComponents)")
      }.font(font).padding([.leading])
    }
    .padding()
    .navigationTitle(String(describing: FloatType.self))
  }
}
