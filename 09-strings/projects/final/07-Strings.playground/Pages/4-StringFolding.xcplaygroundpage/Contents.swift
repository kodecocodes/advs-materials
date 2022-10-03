/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2022 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation


"Café" == "Cafe"
"Café".contains("e")

"Café" == "café"
"Café".contains("c")

let originalString = "H̾e͜l͘l͘ò W͛òr̠l͘d͐!"
originalString.contains("Hello")

let foldedString = originalString.folding(
  options: [.caseInsensitive, .diacriticInsensitive],
  locale: .current)
foldedString.contains("hello")

originalString.localizedStandardContains("hello")
