/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI
import BabyKit

struct FeedView: View {
  @State private var isPickingMoment = false
  @StateObject var feed = Feed()

  var body: some View {
    NavigationView {
      VStack {
        AddFeedItemBar(isBabySleeping: feed.isBabySleeping) { kind in
          print("Selected \(kind.description)")

          if kind == .moment {
            isPickingMoment = true
            return
          }

          feed.addItem(of: kind)
        }
        .padding([.top, .bottom], 8)

        List(feed.items, id: \.date) { item in
          FeedCell(feedItem: item)
        }
      }
      .navigationTitle("BabyTrack")
    }
    .sheet(isPresented: $isPickingMoment) {
      AddMomentView(feed: feed,
                    isPresented: $isPickingMoment)
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
