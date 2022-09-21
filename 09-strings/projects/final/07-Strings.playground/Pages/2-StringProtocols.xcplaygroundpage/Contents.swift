/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

var sampleString = "Lo͞r̉em̗ ȉp͇sum̗ do͞l͙o͞r̉ sȉt̕ a͌m̗et̕"

sampleString.last
let reversedString = String(sampleString.reversed()) // t̕em̗a͌ t̕ȉs r̉o͞l͙o͞d m̗usp͇ȉ m̗er̉o͞L

if let rangeToReplace = sampleString.range(of: "Lo͞r̉em̗") {
  sampleString.replaceSubrange(rangeToReplace, with: "Lorem") // Lorem ȉp͇sum̗ do͞l͙o͞r̉ sȉt̕ a͌m̗et̕
}

extension String {
  subscript(position: Int) -> Self.Element {
    get {
      let characters = Array(self)
      return characters[position]
    }
    set(newValue) {
      let startIndex = self.index(self.startIndex, offsetBy: position)
      let endIndex = self.index(self.startIndex, offsetBy: position + 1)
      let range = startIndex..<endIndex
      replaceSubrange(range, with: [newValue])
    }
  }
}

sampleString[2]
sampleString[2] = "R"

sampleString

for i in 0..<sampleString.count {
  sampleString[i].uppercased()
}

for element in sampleString {
  element.uppercased()
}
