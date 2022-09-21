/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

@main
struct MandelbrotApp: App {
  @StateObject var model = MandelbrotViewModel()

  var body: some Scene {
    WindowGroup {
      NavigationView {
        NavigationSidebar(model: model)
        MandelbrotView(model: model)
          .ignoresSafeArea()
      }
    }
  }
}
