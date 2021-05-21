/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift
/*
 - What are the minimum and maximum representable values of a make-believe `Int4` and `Int10` type?

  Int4
  min: 1000 = -(2^(4-1)) = -8
  max: 0111 = 2^(4-1) - 1 = 7

  Int10
  min: 1000000000 = -(2^(10-1))  = 512
  max: 0111111111 = 2^(10-1) - 1 = 511
*/


/*
 - What bit pattern represents -2 using `Int4`? (Add it to 2 to see if you get zero.)

 start with 2   0010
 flip the bits  1101
 add 1          1110  this is -2

 1110 + 0010 = 10000 (the top bit overflows) 0000
*/

/*
 - List all of the protocols shown in this chapter (the above diagrams) that an `Int32` supports.

 FixedWidthInteger
 BinaryInteger
 SignedInteger
 SignedNumeric
 Numeric
 ExpressibleByIntegerLiteral
 AdditiveArithmetic
 Hashable
 Equatable
 Comparable
 Strideable

 LosslessStringConvertible
 CustomStringConvertible
 */
