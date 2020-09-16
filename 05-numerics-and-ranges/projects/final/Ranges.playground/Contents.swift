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
