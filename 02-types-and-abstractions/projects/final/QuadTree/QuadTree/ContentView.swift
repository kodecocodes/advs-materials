/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2023 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import SwiftUI

struct ContentView: View {

  @StateObject var viewModel = QuadTreeViewModel()

  private var drag: some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged { gesture in
      switch viewModel.mode {
      case .add:
        viewModel.insert(gesture.location)
      case .find:
        viewModel.find(at: gesture.location, searchSize: 40)
      }
    }
  }

  var body: some View {
    NavigationView {
      VStack {
        Picker("Mode", selection: $viewModel.mode) {
          Text("Add Points").tag(Mode.add)
          Text("Find Points").tag(Mode.find)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()

        Text(viewModel.info)

        QuadTreeView(model: viewModel)
          .gesture(drag)
          .onPreferenceChange(SizeKey.self) { key in
            viewModel.windowSize = key
          }
      }.navigationTitle("QuadTree Demo")
      .toolbar {
        Button("Clear") {
          viewModel.clear()
        }
      }
    }.navigationViewStyle(.stack)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

