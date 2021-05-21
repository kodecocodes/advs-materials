/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

struct Book {
  var name: String
  var authors: [String]
  var fpe: String
}

extension Book: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    let parts = value.components(separatedBy: " by: ")
    let bookName = parts.first ?? ""
    let authorNames = parts.last?.components(separatedBy: ",") ?? []
    self.name = bookName
    self.authors = authorNames
    self.fpe = ""
  }
}

var book: Book = """
Expert Swift by: Ehab Amer,Libranner Santos,\
Ray Fix,Shai Mishali
"""

book.name // Expert Swift
book.authors.first // Ehab Amer

var invalidBook: Book = """
Book name is `Expert Swift`. \
Written by: Ehab Amer, Libranner Santos, \
Ray Fix & Shai Mishali
"""

invalidBook.name // Book name is `Expert Swift`. Written
invalidBook.authors.last // Ray Fix & Shai Mishali


extension Book: ExpressibleByStringInterpolation {
  struct StringInterpolation: StringInterpolationProtocol {
    var name: String
    var authors: [String]
    var fpe: String

    init(literalCapacity: Int, interpolationCount: Int) {
      name = ""
      authors = []
      fpe = ""
    }

    mutating func appendLiteral(_ literal: String) {
      // Do something with the literals
    }

    mutating func appendInterpolation(authors list: [String]) {
      authors = list
    }

        mutating func appendInterpolation(_ name: String) {
          self.name = name
        }
  }

  init(stringInterpolation: StringInterpolation) {
    self.authors = stringInterpolation.authors
    self.name = stringInterpolation.name
    self.fpe = stringInterpolation.fpe
  }
}

var interpolatedBook: Book = """
The awesome team of authors \(authors:
  ["Ehab Amer", "Libranner Santos", "Ray Fix", "Shai Mishali"]) \
wrote this great book. Titled \("Expert Swift")
"""

interpolatedBook.name

extension Book.StringInterpolation {
  mutating func appendInterpolation(fpe name: String) {
    fpe = name
  }
}


var interpolatedBookWithFPE: Book = """
\("Expert Swift") had an amazing \
final pass editor \(fpe: "Eli Ganim")
"""

extension Book.StringInterpolation {
  mutating func appendInterpolation(bookName name: String) {
    self.name = name
  }

  mutating func appendInterpolation(anAuthor name: String) {
    self.authors.append(name)
  }
}

var interpolatedBook2: Book = """
\(anAuthor: "Ray Fix") & \(anAuthor: "Shai Mishali") \
were authors in \(bookName: "Expert Swift")
"""

extension String.StringInterpolation {
  mutating func appendInterpolation(_ book: Book) {
    appendLiteral("The Book \"")
    appendLiteral(book.name)
    appendLiteral("\"")

    if !book.authors.isEmpty {
      appendLiteral(" Authored by: ")
      for author in book.authors {
        if author == book.authors.first {
          appendLiteral(author)
        } else {
          if author == book.authors.last {
            appendLiteral(", & ")
            appendLiteral(author)
            appendLiteral(".")
          } else {
            appendLiteral(", ")
            appendLiteral(author)
          }
        }
      }
    }

    if !book.fpe.isEmpty {
      appendLiteral(" Final Pass Edited by: ")
      appendLiteral(book.fpe)
    }
  }
}

interpolatedBook.fpe = "Eli Ganim"
var string2 = "\(interpolatedBook)"
