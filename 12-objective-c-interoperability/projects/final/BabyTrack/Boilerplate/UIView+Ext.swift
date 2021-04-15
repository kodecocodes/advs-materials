/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get { layer.cornerRadius }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = true
    }
  }
}
