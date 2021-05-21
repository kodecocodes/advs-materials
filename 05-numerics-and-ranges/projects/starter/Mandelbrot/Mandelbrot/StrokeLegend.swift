/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

extension Shape {
  func stroke(_ floatSize: FloatSize) -> some View {
    switch floatSize {
    case .float16:
      return stroke(Color.red, style: .init(lineWidth: 1))
    case .float32:
      return stroke(Color.green, style: .init(lineWidth: 3))
    case .float64, .simd8Float64:
      return stroke(Color.blue, style: .init(lineWidth: 7))
    case .float80:
      return stroke(Color.orange, style: .init(lineWidth: 9))
    }
  }
}

private struct HorizontalLine: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
    return path
  }
}

struct StrokeLegend: View {
  var body: some View {
    VStack {
      ForEach(FloatSize.pathSizes, id: \.self.rawValue) { floatType in
        HStack {
          HorizontalLine().stroke(floatType)
          Text(floatType.name)
        }
      }
    }
    .frame(width: 150, height: 100)
    .padding(30)
    .background(Color.black.opacity(0.1))
    .border(Color.black)
  }
}
