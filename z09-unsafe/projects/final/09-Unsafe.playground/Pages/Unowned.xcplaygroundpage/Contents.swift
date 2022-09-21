/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class Something {
  var value: String

  func operate() {
    print(self.value)
  }

  init(value: String) {
    self.value = value
  }
}

class ClosureWorker {
  var closure: () -> Void
  func execute() {
    closure()
  }

  init(item: Something) {
    self.closure = { [unowned(unsafe) item] in
      item.operate()
    }
  }
}

var item: Something? = Something(value: "Hello World")
var worker = ClosureWorker(item: item!)
item = nil
worker.execute()
