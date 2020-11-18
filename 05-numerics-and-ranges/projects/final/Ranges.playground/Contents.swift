/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

enum Number: Int, Comparable {
  static func < (lhs: Number, rhs: Number) -> Bool {
    lhs.rawValue < rhs.rawValue
  }

  case zero, one, two, three, four
}

let longForm =
  Range<Number>(uncheckedBounds: (lower: .one, upper: .three))

let shortForm = Number.one ..< .three

longForm == shortForm

shortForm.contains(.zero)
shortForm.contains(.one)
shortForm.contains(.two)
shortForm.contains(.three)

let longFormClosed =
  ClosedRange<Number>(uncheckedBounds: (lower: .one, upper: .three))
let shortFormClosed = Number.one ... .three

longFormClosed == shortFormClosed

shortFormClosed.contains(.zero)
shortFormClosed.contains(.one)
shortFormClosed.contains(.two)
shortFormClosed.contains(.three)

let r1 = ...Number.three
let r2 = ..<Number.three
let r3 = Number.zero...

extension Number: Strideable {
  public func distance(to other: Number) -> Int {
    other.rawValue - rawValue
  }

  public func advanced(by n: Int) -> Number {
    Number(rawValue: rawValue + n)!
  }

  public typealias Stride = Int
}

for i in 1 ..< 3 {
  print(i)
}

for i in Number.one ..< .three {
  print(i)
}

for i in (Number.one ..< .three).reversed() {
  print(i)
}

for i in stride(from: Number.two, to: .zero, by: -1) {
  print(i)
}

for i in stride(from: Number.two, through: .one, by: -1) {
  print(i)
}

func find<R: RangeExpression>(value: R.Bound, in range: R)
  -> Bool {
  range.contains(value)
}

find(value: Number.one, in: Number.zero ... .two)
find(value: Number.one, in: ...Number.two)
find(value: Number.one, in: ..<Number.three)
