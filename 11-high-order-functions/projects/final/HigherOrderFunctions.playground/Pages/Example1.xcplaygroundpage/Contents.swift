/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2020.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

class TextPrinter {
  var formatter: ParagraphFormatterProtocol

  init(formatter: ParagraphFormatterProtocol) {
    self.formatter = formatter
  }

  func printText(_ paragraphs: [String]) {
    for text in paragraphs {
      let formattedText = formatter.formatParagraph(text)
      print(formattedText)
    }
  }
}

protocol ParagraphFormatterProtocol {
  func formatParagraph(_ text: String) -> String
}

class SimpleFormatter: ParagraphFormatterProtocol {
  func formatParagraph(_ text: String) -> String {
    guard !text.isEmpty else { return text }
    var formattedText = text.prefix(1).uppercased() + text.dropFirst()
    if let lastCharacter = formattedText.last,
       !lastCharacter.isPunctuation {
      formattedText += "."
    }
    return formattedText
  }
}

let simpleFormatter = SimpleFormatter()
let textPrinter = TextPrinter(formatter: simpleFormatter)

let exampleParagraphs = [
  "basic text example",
  "Another text example!!",
  "one more text example"
]

textPrinter.printText(exampleParagraphs)

extension Array where Element == String {
  func printFormatted(formatter: ParagraphFormatterProtocol) {
    let textPrinter = TextPrinter(formatter: formatter)
    textPrinter.printText(self)
  }
}

print("----------------------")

exampleParagraphs.printFormatted(formatter: simpleFormatter)
