/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI

struct SizeKey: PreferenceKey {
  static var defaultValue: CGSize? = nil
  static func reduce(value: inout CGSize?,
                     nextValue: () -> CGSize?) {
    value = nextValue() ?? value
  }
}

struct QuadTreeView: View {
  @Binding var quadTree: QuadTreeOfPoints

  var points: [CGPoint] {
    quadTree.allItems()
  }

  var regions: [CGRect] {
    quadTree.allRegions()
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      GeometryReader { proxy in
        Color.white
        ForEach(Array(regions.enumerated()), id: \.offset) { (offset, element) in
          Rectangle()
            .strokeBorder(lineWidth: 0.5)
            .foregroundColor(.gray)
            .offset(x: element.origin.x * proxy.size.width,
                    y: element.origin.y * proxy.size.height)
            .frame(width: element.width * proxy.size.width,
                   height: element.height * proxy.size.height,
                   alignment: .topLeading)
        }

        ForEach(Array(points.enumerated()),
                id: \.offset) { (offset, element) in
          Circle().offset(x: element.x * proxy.size.width,
                          y: element.y * proxy.size.height)
            .frame(width: 3, height: 3)
            .foregroundColor(.blue)
        }
      }
    }
    .background(GeometryReader { proxy in
      Color.clear.preference(key: SizeKey.self, value: proxy.size)
    })
  }
}
