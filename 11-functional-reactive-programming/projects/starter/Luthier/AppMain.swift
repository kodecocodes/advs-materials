/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import SwiftUI

@main
struct AppMain: App {
  var body: some Scene {
    WindowGroup {
      BuildView()
    }
  }
  
  init() {
    URLProtocol.registerClass(MockExchangeService.self)
  }
}
