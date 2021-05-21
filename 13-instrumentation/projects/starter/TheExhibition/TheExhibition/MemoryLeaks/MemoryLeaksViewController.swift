/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import UIKit

class MemoryLeaksViewController: UIViewController {
  @IBOutlet var infoLabel: UILabel!
  var infoWriter: InformationWriter?
  override func viewDidLoad() {
    super.viewDidLoad()
    infoWriter = InformationWriter(writer: self)
    infoWriter?.doSomething()
  }

  @IBAction func buttonPressed() {
    infoWriter?.doSomething()
  }
}

// MARK: - WriterProtocol
extension MemoryLeaksViewController: WriterProtocol {
  func writeText(_ text: String) {
    infoLabel.text = text
  }
}
