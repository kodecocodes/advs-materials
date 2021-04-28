/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2021.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

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
