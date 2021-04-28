/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

func formatParagraph(_ text: String) -> String {
  guard !text.isEmpty else { return text }
  var formattedText = text.prefix(1).uppercased() + text.dropFirst()
  if let lastCharacter = formattedText.last,
     !lastCharacter.isPunctuation {
    formattedText += "."
  }
  return formattedText
}

extension Array where Element == String {
  func printFormatted(formatter: ((String) -> String)) {
    for string in self {
      let formattedString = formatter(string)
      print(formattedString)
    }
  }
}

let exampleParagraphs = [
  "basic text example",
  "Another text example!!",
  "one more text example"
]

exampleParagraphs.printFormatted(formatter: formatParagraph(_:))

print("------------------")

let theFunction = formatParagraph
exampleParagraphs.printFormatted(formatter:theFunction)

print("------------------")

exampleParagraphs.printFormatted { text in
  guard !text.isEmpty else { return text }
  var formattedText = text.prefix(1).uppercased() + text.dropFirst()
  if let lastCharacter = formattedText.last,
     !lastCharacter.isPunctuation {
    formattedText += "."
  }
  return formattedText
}

print("------------------")

exampleParagraphs.printFormatted(formatter: { formatParagraph($0) })
