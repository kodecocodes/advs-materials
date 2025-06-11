/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import SwiftUI
import BabyKit

struct FeedView: View {
  let feed = Feed()

  var body: some View {
    Text("Hello World!")
      .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
