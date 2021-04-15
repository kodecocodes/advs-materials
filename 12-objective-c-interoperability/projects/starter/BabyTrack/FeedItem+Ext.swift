/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import BabyKit

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
