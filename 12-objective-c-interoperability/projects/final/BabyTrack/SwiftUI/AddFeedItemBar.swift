/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI
import BabyKit

struct AddFeedItemBar: View {
  let isBabySleeping: Bool
  let onKindTapped: (FeedItem.Kind) -> Void

  var body: some View {
    let kinds: [FeedItem.Kind] = [.bottle, .food, .sleep,
                                  .diaper, .moment]

    HStack(spacing: 16) {
      ForEach(kinds, id: \.self) { kind in
        let type = kind == .sleep && isBabySleeping ? .awake : kind

        Button(type.emoji) {
          onKindTapped(type)
        }
        .frame(minWidth: 52, maxWidth: .infinity,
               minHeight: 52, idealHeight: 52)
        .background(Color(kind.color))
        .cornerRadius(4)
      }
    }
    .padding([.leading, .trailing])
  }
}
