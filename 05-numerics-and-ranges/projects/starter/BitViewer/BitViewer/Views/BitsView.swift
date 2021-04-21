/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift
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
