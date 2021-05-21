/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI
import BabyKit

struct FeedCell: View {
  private let feedItem: FeedItem
  private let formatter = RelativeDateTimeFormatter()

  init(feedItem: FeedItem) {
    self.feedItem = feedItem
    formatter.formattingContext = .standalone
  }

  var body: some View {
    HStack(alignment: .top) {
      Text(feedItem.kind.emoji)
        .frame(width: 44, height: 44, alignment: .center)
        .background(Color(feedItem.kind.color))
        .cornerRadius(22)

      VStack(alignment: .leading) {
        Text(feedItem.kind.title)
          .font(.headline)

        Text(feedItem.date, formatter: formatter)
          .font(.subheadline)
          .foregroundColor(.gray)

        if let attachmentURL = feedItem.attachmentURL {
          Spacer(minLength: 4)

          URLImage(url: attachmentURL)
            .frame(minWidth: 0, minHeight: 140, idealHeight: 140)
            .clipped()
        }
      }

      Spacer()
    }
    .frame(minHeight: 64)
  }
}
