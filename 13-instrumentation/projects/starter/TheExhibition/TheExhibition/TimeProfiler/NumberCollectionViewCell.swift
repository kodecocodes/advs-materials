/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {
  @IBOutlet var numberLabel: UILabel?
  @IBOutlet var countLabel: UILabel?
  @IBOutlet var timeLabel: UILabel?

  var number: (Int, Int)? {
    didSet {
      guard let newValue = number else {
        return
      }
      numberLabel?.text = "\(newValue.0)"
      countLabel?.text = "\(newValue.1)"
    }
  }

  var time: String? {
    didSet {
      guard let newValue = time else {
        return
      }
      timeLabel?.text = newValue
    }
  }
}
