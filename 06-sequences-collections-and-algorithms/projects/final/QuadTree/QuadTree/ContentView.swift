/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI

struct ContentView: View {
  @State private var size: CGSize?
  @State private var quadTree = QuadTreeOfPoints(region: CGRect(origin: .zero, size: CGSize(width: 1, height: 1)))

  var drag: some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged { gesture in

      guard let size = size else {
        return
      }
      let x = gesture.location.x / size.width
      let y = gesture.location.y / size.height
      quadTree.insert(CGPoint(x: x, y: y))
    }
  }

  var body: some View {
    QuadTreeView(quadTree: $quadTree)
      .gesture(drag)
      .onPreferenceChange(SizeKey.self) { key in
        size = key
      }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
