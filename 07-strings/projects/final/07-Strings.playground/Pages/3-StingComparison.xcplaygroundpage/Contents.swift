/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2020.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

let OwithDiaersis = "Ö"
let zee = "Z"

OwithDiaersis > zee // true

// German 🇩🇪
OwithDiaersis.compare(zee, locale: Locale(identifier: "DE")) == .orderedAscending

// Sweden 🇸🇪
OwithDiaersis.compare(zee, locale: Locale(identifier: "SE")) == .orderedAscending

"11".localizedCompare("2") == .orderedAscending

"11".localizedStandardCompare("2") == .orderedAscending
