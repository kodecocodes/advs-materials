/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import UIKit
import BabyKit

@objc extension FeedItem {
  var attachmentURL: URL? {
    attachmentId.flatMap {
      try? FileManager.default.url(for: .documentDirectory,
                                   in: .userDomainMask,
                                   appropriateFor: nil,
                                   create: false)
        .appendingPathComponent("\($0).jpg")
    }
  }
  
  @objc(colorForKind:)
  static func color(for kind: Kind) -> UIColor {
    kind.color
  }

  @objc(emojiForKind:)
  static func emoji(for kind: Kind) -> String {
    kind.emoji
  }

  @objc(titleForKind:)
  static func title(for kind: Kind) -> String {
    kind.title
  }
}

extension FeedItem.Kind {
  var title: String {
    switch self {
    case .bottle:
      return "Drank a bottle"
    case .food:
      return "Ate food"
    case .sleep:
      return "Slept"
    case .awake:
      return "Woke up"
    case .diaper:
      return "Got a new diaper"
    case .moment:
      return "Captured a moment"
    default:
      return ""
    }
  }

  var emoji: String {
    switch self {
    case .bottle:
      return "🍼"
    case .food:
      return "🥗"
    case .sleep:
      return "😴"
    case .awake:
      return "👶"
    case .diaper:
      return "💩"
    case .moment:
      return "📸"
    default:
      return ""
    }
  }

  var color: UIColor {
    switch self {
    case .bottle:
      return UIColor(r: 240, g: 234, b: 214)
    case .food:
      return UIColor(r: 173, g: 255, b: 47)
    case .sleep, .awake:
      return UIColor(r: 255, g: 191, b: 0)
    case .diaper:
      return UIColor(r: 244, g: 164, b: 96)
    case .moment:
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
