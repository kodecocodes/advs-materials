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
///

import SwiftUI

private extension FixedWidthInteger {
  mutating func toggleBit(at index: Int) {
    self ^= (0x1 << index)
  }
}

/// Add color for the different bit semantics.
extension BitSemantic {
  var color: Color {
    switch self {
    case .sign:
      return Color.blue.opacity(0.15)
    case .significand:
      return Color.red.opacity(0.15)
    case .exponent:
      return Color.green.opacity(0.15)
    }
  }
  var semanticLabel: String {
    switch self {
    case .sign:
      return "±"
    case .exponent:
      return "^"
    case .significand:
      return "·"
    }
  }
}

struct BitsView<IntType: FixedWidthInteger>: View {
  @EnvironmentObject var prefereces: Preferences

  var value: Binding<IntType>
  var bitSemanticProvider: (Int) -> BitSemantic?

  let foregroundColor = Color.black
  let bitSizePoints: CGFloat = 52
  let interBitSpacing: CGFloat = 7
  let spacerSizePoints: CGFloat = 2

  private func color(at index: Int) -> Color {
    bitSemanticProvider(index)?.color ?? Color.black.opacity(0.05)
  }

  private func semanticLabel(at index: Int) -> String {
    bitSemanticProvider(index)?.semanticLabel ?? ""
  }

  private func bitView(_ bit: FixedWidthIntegerBit) -> some View {
    VStack {
      Text(bit.string)
        .frame(width: bitSizePoints, height: bitSizePoints)
        .font(.system(size: bitSizePoints * 0.5, weight: .regular, design: .monospaced))
        .foregroundColor(foregroundColor)
        .border(foregroundColor, width: 1)
        .background(
          ZStack {
            Text(semanticLabel(at: bit.id))
              .font(.system(size: bitSizePoints * 0.45, weight: .regular, design: .monospaced))
              .position(x: bitSizePoints * 0.15, y: bitSizePoints * 0.15)
            color(at: bit.id)
          }
        )
        .onTapGesture {
          value.wrappedValue.toggleBit(at: bit.id)
        }
      Text(String(bit.id))
        .frame(width: bitSizePoints, height: bitSizePoints / 2)
        .font(.system(size: bitSizePoints * 0.3, weight: .regular, design: .monospaced))
        .foregroundColor(foregroundColor)
        .border(foregroundColor, width: 1)
        .offset(y: -1)
    }
  }

  private func isSignedBit(at index: Int) -> Bool {
    IntType.isSigned && index == IntType.bitWidth - 1
  }

  private func spacer() -> some View {
    Color.clear.frame(width: spacerSizePoints)
  }

  private func isByteBoundary(at index: Int) -> Bool {
    index % 8 == 0 && index != 0
  }

  private var bitsHorizontal: some View {
    GeometryReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHGrid(
          rows: [GridItem(.fixed(bitSizePoints))],
          spacing: interBitSpacing) {
          ForEach(value.wrappedValue.bits) { bit in
            bitView(bit)
            if isByteBoundary(at: bit.id) {
              spacer()
            }
          }
        }
      }.frame(width: proxy.size.width )
    }.frame(height: bitSizePoints * 1.5)
  }

  private var bitsStacked: some View {
    VStack(spacing: 10) {
      ForEach(Array(value.wrappedValue.bytesOfBits.enumerated()), id: \.offset) { byteOffset in
        HStack(spacing: interBitSpacing) {
          ForEach(byteOffset.element) { bit in
            bitView(bit)
          }
        }
      }
    }.padding(.top, 10)
  }

  var body: some View {
    if prefereces.displayBitsStacked {
      bitsStacked
    } else {
      bitsHorizontal
    }
  }
}
