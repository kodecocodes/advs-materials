/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import Foundation
import Combine
import SwiftUI

@dynamicMemberLookup
public class Feed: ObservableObject {
  @Published public var items: [FeedItem] = []
  private let legacyFeed = __Feed()

  public init() {
    items = legacyFeed.loadItems()
  }

  public func addItem(of kind: FeedItem.Kind) {
    items.insert(legacyFeed.addItem(of: kind), at: 0)
  }

  public func addMoment(with attachmentId: UUID) {
    items.insert(
      legacyFeed.add(FeedItem(kind: .moment,
                              date: nil,
                              attachmentId: attachmentId)),
                     at: 0
    )
  }

  public func storeImage(_ image: UIImage) -> UUID? {
    legacyFeed.storeImage(image)
  }
  
  public subscript<T>(dynamicMember keyPath: KeyPath<__Feed, T>) -> T {
    legacyFeed[keyPath: keyPath]
  }
}
