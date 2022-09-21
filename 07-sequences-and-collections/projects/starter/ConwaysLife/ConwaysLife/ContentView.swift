/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

struct ContentView: View {

  @StateObject var simulation = LifeSimulation(size: 40)

  var body: some View {
    NavigationView {
      LifeView(model: simulation).navigationBarTitle("Conway's Game of Life", displayMode: .inline)
    }.navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
