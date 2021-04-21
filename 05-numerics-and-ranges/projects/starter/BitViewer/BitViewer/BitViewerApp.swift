/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI

@main
struct BitViewerApp: App {
  @StateObject var model = ModelStore()
  @StateObject var preferences = Preferences()

  var body: some Scene {
    WindowGroup {
      BitViewerContentView(model: model).environmentObject(preferences)
    }
  }
}
