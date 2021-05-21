/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

private extension BitSemantic {
  var longName: String {
    switch self {
    case .sign:
      return "Sign Bit"
    case .exponent:
      return "Exponent Bits"
    case .significand:
      return "Significand Bits"
    }
  }
}

struct BitLegend: View {
  enum Kind { case signedInteger, floatingPoint }
  let kind: Kind

  var items: [BitSemantic] {
    switch kind {
    case .signedInteger:
      return [BitSemantic.sign]
    case .floatingPoint:
      return BitSemantic.allCases
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: spacing) {
      ForEach(items, id: \.self) { item in
        HStack {
          Text(item.semanticLabel)
            .frame(width: squareSize, height: squareSize)
            .border(borderColor)
            .background(item.color)
          Text(item.longName).font(font)
        }
      }
    }
  }

  // MARK: - View constants
  let spacing: CGFloat = 10
  let font: Font = .system(size: 25, weight: .bold, design: .monospaced)
  let squareSize: CGFloat = 30
  let borderColor = Color.black
}
