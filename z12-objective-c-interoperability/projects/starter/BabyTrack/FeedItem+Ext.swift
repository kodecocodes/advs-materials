/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import UIKit
import BabyKit
import Combine

extension Publisher {
  func sample(every count: Int) -> AnyPublisher<Output, Failure> {
    scan((0, nil as Output?)) { args, value in
      (args.0 + 1, value)
    }
    .compactMap { idx, value in
      guard idx % count == 0 else { return nil }
      return value
    }
    .eraseToAnyPublisher()
  }
}

extension FeedItem {
  var attachmentURL: URL? {
    attachmentId.flatMap {
      try? FileManager.default.url(for: .documentDirectory,
                                   in: .userDomainMask,
                                   appropriateFor: nil,
                                   create: false)
        .appendingPathComponent("\($0).jpg")
    }
  }
}

extension FeedItemKind {
  var title: String {
    switch self {
    case FeedItemKindBottle:
      return "Drank a bottle"
    case FeedItemKindFood:
      return "Ate food"
    case FeedItemKindSleep:
      return "Slept"
    case FeedItemKindAwake:
      return "Woke up"
    case FeedItemKindDiaper:
      return "Got a new diaper"
    case FeedItemKindMoment:
      return "Captured a moment"
    default:
      return ""
    }
  }

  var emoji: String {
    switch self {
    case FeedItemKindBottle:
      return "🍼"
    case FeedItemKindFood:
      return "🥗"
    case FeedItemKindSleep:
      return "😴"
    case FeedItemKindAwake:
      return "👶"
    case FeedItemKindDiaper:
      return "💩"
    case FeedItemKindMoment:
      return "📸"
    default:
      return ""
    }
  }

  var color: UIColor {
    switch self {
    case FeedItemKindBottle:
      return UIColor(r: 240, g: 234, b: 214)
    case FeedItemKindFood:
      return UIColor(r: 173, g: 255, b: 47)
    case FeedItemKindSleep, FeedItemKindAwake:
      return UIColor(r: 255, g: 191, b: 0)
    case FeedItemKindDiaper:
      return UIColor(r: 244, g: 164, b: 96)
    case FeedItemKindMoment:
      return UIColor(r: 83, g: 83, b: 83)
    default:
      return .white
    }
  }
}

private extension UIColor {
  convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
    self.init(red: CGFloat(r) / 255,
              green: CGFloat(g) / 255,
              blue: CGFloat(b) / 255,
              alpha: a)
  }
}
