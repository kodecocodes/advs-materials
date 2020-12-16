/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI

/// PreferenceKey used to determine the size of the layed out image.
struct SizeKey: PreferenceKey {
  static var defaultValue: CGSize?
  static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
    value = value ?? nextValue()
  }
}

/// A view display the a simulation of a life simulation.
struct LifeView: View {
  @ObservedObject var model: LifeSimulation
  @State private var imageSize: CGSize?

  /// Drag gesture that lets you draw cells
  var drag: some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onChanged { drag in
        guard let imageSize = imageSize else { return }
        let column = Int(drag.location.x /
                          imageSize.width *
                          CGFloat(model.cells.width))
        let row = Int(drag.location.y /
                        imageSize.height *
                        CGFloat(model.cells.height))
        model.setLive(row: row, column: column)
      }
  }

  // View showing the simulation and some controls.
  var body: some View {
    VStack {
      Text("Epoch: \(model.epoch)")
        .font(.system(size: 25, weight: .bold, design: .monospaced))
      Image(uiImage: model.cellImage)
        .interpolation(.none)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .background(GeometryReader { proxy in
          Color.clear.preference(key: SizeKey.self, value: proxy.size)
        })
        .gesture(drag)
        .onPreferenceChange(SizeKey.self) { key in
          imageSize = key // report the size of the image layed out.
        }
      Spacer()
      HStack {
        Group {
        Button("Clear") {
          model.clear()
        }
        Button(model.isRunning ? "Stop" : "Start") {
          model.isRunning.toggle()
        }
        }.frame(width: 100)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        .foregroundColor(Color.white)
        .font(.headline)
      }
    }.padding()
  }
}
