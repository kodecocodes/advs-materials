/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
Advanced Swift by: Ehab Amer,Libranner Santos,\
Ray Fix,Shai Mishali
"""

book.name // Advanced Swift
book.authors.first // Ehab Amer

var invalidBook: Book = """
Book name is `Advanced Swift`. \
Written by: Ehab Amer, Libranner Santos, \
Ray Fix & Shai Mishali
"""

invalidBook.name // Book name is `Advanced Swift`. Written
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
wrote this great book. Titled \("Advanced Swift")
"""

interpolatedBook.name

extension Book.StringInterpolation {
    mutating func appendInterpolation(fpe name: String) {
        fpe = name
    }
}


var interpolatedBookWithFPE: Book = """
\("Advanced Swift") had an amazing \
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
were authors in \(bookName: "Advanced Swift")
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
