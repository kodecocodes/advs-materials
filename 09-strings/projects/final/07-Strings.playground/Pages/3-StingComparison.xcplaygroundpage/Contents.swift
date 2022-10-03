/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2022 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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
