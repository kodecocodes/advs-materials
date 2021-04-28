/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2021.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

let eAcute = "\u{E9}"
let combinedEAcute = "\u{65}\u{301}"

eAcute.count
combinedEAcute.count

eAcute == combinedEAcute // true


let eAcute_objC: NSString = "\u{E9}"
let combinedEAcute_objC: NSString = "\u{65}\u{301}"

eAcute_objC.length
combinedEAcute_objC.length

eAcute_objC == combinedEAcute_objC // true

let acute = "\u{301}"
let smallE = "\u{65}"

acute.count
smallE.count

let combinedEAcute2 = smallE + acute

combinedEAcute2.count

let lorem = "Lo͞r̉em̗"

Array(lorem.unicodeScalars)
Array(lorem.utf8)
Array(lorem.utf16)

let flags = "🏳️🏴🏴‍☠️🏁"
Array(flags.unicodeScalars)
Array(flags.utf8)
Array(flags.utf16)
