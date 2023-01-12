/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2023 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift


import SwiftUI

struct SizeKey: PreferenceKey {
  static var defaultValue: CGSize? = nil
  static func reduce(value: inout CGSize?,
                     nextValue: () -> CGSize?) {
    value = nextValue() ?? value
  }
}

struct QuadTreeView: View {
  @ObservedObject var model: QuadTreeViewModel

  @ViewBuilder
  private var findWindow: some View {
    if let findWindow = model.findWindow {
      Rectangle()
        .strokeBorder(lineWidth: 2)
        .foregroundColor(.red)
        .offset(x: findWindow.origin.x, y: findWindow.origin.y)
        .frame(width: findWindow.width, height: findWindow.height,
               alignment: .topLeading)
    }
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      GeometryReader { proxy in
        Color.white
        ForEach(Array(model.regions.enumerated()), id: \.offset) { (offset, element) in
          Rectangle()
            .strokeBorder(lineWidth: 0.5)
            .foregroundColor(.gray)
            .offset(x: element.origin.x * proxy.size.width,
                    y: element.origin.y * proxy.size.height)
            .frame(width: element.width * proxy.size.width,
                   height: element.height * proxy.size.height,
                   alignment: .topLeading)
        }
        ForEach(Array(model.points.enumerated()),
                id: \.offset) { (offset, element) in
          Circle().offset(x: element.x * proxy.size.width,
                          y: element.y * proxy.size.height)
            .frame(width: 3, height: 3)
            .foregroundColor(.blue)
        }
        findWindow
        ForEach(Array(model.foundPoints.enumerated()),
                id: \.offset) { (offset, element) in
          Circle().offset(x: element.x * proxy.size.width,
                          y: element.y * proxy.size.height)
            .frame(width: 5, height: 5)
            .foregroundColor(.red)
        }
      }
    }
    .background(GeometryReader { proxy in
      Color.clear.preference(key: SizeKey.self, value: proxy.size)
    })
  }
}
