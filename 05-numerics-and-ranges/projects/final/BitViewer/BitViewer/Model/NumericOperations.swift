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

enum IntegerOperation<IntType: FixedWidthInteger> {
  typealias Operation = (IntType) -> IntType

  struct Section: Identifiable {
    let id: String
    let items: [Item]
  }

  struct Item: Identifiable {
    let id: String
    let operation: Operation
  }

  static var menu: [Section] {
    [
      Section(id: "Set Value", items:
      [
        Item(id: "value = 0") { _ in 0 },
        Item(id: "value = 1") { _ in 1 },
        Item(id: "all ones") { _ in ~IntType(0) },
        Item(id: "value = -1") { _ in -1 },
        Item(id: "max") { _ in IntType.max },
        Item(id: "min") { _ in IntType.min },
        Item(id: "random") { _ in IntType.random(in: IntType.min...IntType.max) }
      ]),
      Section(id: "Endian", items:
      [
        Item(id: "bigEndian") { value in value.bigEndian },
        Item(id: "littleEndian") { value in value.littleEndian },
        Item(id: "byteSwapped") { value in value.byteSwapped }
      ]),
      Section(id: "Bit Manipulation", items:
      [
        Item(id: "value << 1") { value in value << 1 },
        Item(id: "value >> 1") { value in value >> 1 },
        Item(id: "toggle") { value in ~value }
      ]),
      Section(id: "Arithmetic", items:
      [
        Item(id: "value + 1") { value in value &+ 1 },
        Item(id: "value - 1") { value in value &- 1 },
        Item(id: "negate") { value in ~value &+ 1 }
      ])
    ]
  }
}

enum FloatingPointOperation<FloatType: BinaryFloatingPoint> {
  typealias Operation = (FloatType) -> FloatType

  struct Section: Identifiable {
    let id: String
    let items: [Item]
  }

  struct Item: Identifiable {
    let id: String
    let operation: Operation
  }

  static var menu: [Section] {
    [
      Section(id: "Set Value", items:
      [
        Item(id: "value = 0") { _ in 0 },
        Item(id: "value = 0.1") { _ in FloatType(0.1) },
        Item(id: "value = 0.2") { _ in FloatType(0.2) },
        Item(id: "value = 0.5") { _ in FloatType(0.5) },
        Item(id: "value = 1") { _ in 1 },
        Item(id: "value = -1") { _ in -1 },
        Item(id: "value = pi") { _ in FloatType.pi },
        Item(id: "value = 100") { _ in 100 },
        Item(id: "infinity") { _ in FloatType.infinity },
        Item(id: "NaN") { _ in FloatType.nan },
        Item(id: "Signaling NaN") { _ in FloatType.signalingNaN },
        Item(id: "greatestFiniteMagnitude") { _ in FloatType.greatestFiniteMagnitude },
        Item(id: "leastNormalMagnitude") { _ in FloatType.leastNormalMagnitude },
        Item(id: "ulpOfOne") { _ in FloatType.ulpOfOne }
      ]),
      Section(id: "Stepping", items:
      [
        Item(id: ".nextUp") { $0.nextUp },
        Item(id: ".nextDown") { $0.nextDown },
        Item(id: ".ulp") { $0.ulp },
        Item(id: "add 0.1") { $0 + 0.1 },
        Item(id: "subtract 0.1") { $0 - 0.1 }
      ]),
      Section(id: "Functions", items:
      [
        Item(id: ".squareRoot()") { $0.squareRoot() },
        Item(id: "1/value") { 1/$0 }
      ])
    ]
  }
}
