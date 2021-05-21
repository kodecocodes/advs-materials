/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

struct ContentView: View {

  @StateObject var model = QuadTreeViewModel()

  private var drag: some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged { gesture in
      switch model.mode {
      case .add:
        model.insert(gesture.location)
      case .find:
        model.find(at: gesture.location, searchSize: 40)
      }
    }
  }

  var body: some View {
    NavigationView {
      VStack {
        Picker("Mode", selection: $model.mode) {
          Text("Add Points").tag(Mode.add)
          Text("Find Points").tag(Mode.find)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()

        Text(model.info)

        QuadTreeView(model: model)
          .gesture(drag)
          .onPreferenceChange(SizeKey.self) { key in
            model.windowSize = key
          }
      }.navigationTitle("QuadTree Demo")
      .toolbar {
        Button("Clear") {
          model.clear()
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

